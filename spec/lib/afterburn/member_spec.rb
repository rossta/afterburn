require 'spec_helper'
require 'ostruct'

describe Afterburn::Member, :vcr, :record => :new_episodes do
  def fetch_trello_member
    Trello::Member.find('rossta')
  end

  let(:trello_member) { fetch_trello_member }

  describe "self.save" do
    it "should persist trello member" do
      member = Afterburn::Member.new(trello_member)
      Afterburn::Member.save(member)
      Trello::Member.should_not_receive(:find)
      loaded_member = Afterburn::Member.find(trello_member.id)
      loaded_member.trello_member.should eq(trello_member)
    end
  end

  describe "self.find" do
    it "should get member via api and marshal result if not found in redis" do
      Afterburn.redis.get("member:#{trello_member.id}").should be_nil
      member = Afterburn::Member.find(trello_member.id)
      member.trello_member.should eq(trello_member)
      Marshal.restore(Afterburn.redis.get("member:#{trello_member.id}")).should eq(trello_member)
    end

    it "should get load marshaled member result if found in redis" do
      Afterburn::Member.find(trello_member.id)
      Trello::Member.should_not_receive(:find)
      member = Afterburn::Member.find(trello_member.id)
      member.trello_member.should eq(trello_member)
    end
  end

  it { Afterburn::Member.new(trello_member).id.should eq(trello_member.id) }

  describe "save" do
    it "marshals trello member in redis" do
      Afterburn.redis.get("member:#{trello_member.id}").should be_nil
      member = Afterburn::Member.new(trello_member)
      member.save
      Marshal.restore(Afterburn.redis.get("member:#{trello_member.id}")).should eq(trello_member)
    end
  end

  describe "fetch" do
    it "retrieves and saves trello member via api" do
      member = Afterburn::Member.new(trello_member)
      new_trello_member = OpenStruct.new(:id => trello_member.id)
      Trello::Member.should_receive(:find).with(member.id).and_return(new_trello_member)
      member.fetch
      member.trello_member.should eq(new_trello_member)
      Marshal.restore(Afterburn.redis.get("member:#{trello_member.id}")).should eq(new_trello_member)
    end

  end

end