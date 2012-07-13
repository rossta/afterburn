require 'spec_helper'
require 'ostruct'

describe Afterburn::List, :vcr, :record => :new_episodes do
  def fetch_trello_list
    Trello::Member.find('rossta').boards.first.lists.first
  end

  let(:trello_list) { fetch_trello_list }

  describe "self.save" do
    it "should persist trello list" do
      list = Afterburn::List.new(trello_list)
      Afterburn::List.save(list)
      Trello::List.should_not_receive(:find)
      loaded_list = Afterburn::List.find(trello_list.id)
      loaded_list.trello_list.should eq(trello_list)
    end
  end

  describe "self.find" do
    it "should get list via api and marshal result if not found in redis" do
      Afterburn.redis.get("list:#{trello_list.id}").should be_nil
      list = Afterburn::List.find(trello_list.id)
      list.trello_list.should eq(trello_list)
      Marshal.restore(Afterburn.redis.get("list:#{trello_list.id}")).should eq(trello_list)
    end

    it "should get load marshaled list result if found in redis" do
      Afterburn::List.find(trello_list.id)
      Trello::List.should_not_receive(:find)
      list = Afterburn::List.find(trello_list.id)
      list.trello_list.should eq(trello_list)
    end
  end

  it { Afterburn::List.new(trello_list).id.should eq(trello_list.id) }

  describe "save" do
    it "marshals trello list in redis" do
      Afterburn.redis.get("list:#{trello_list.id}").should be_nil
      list = Afterburn::List.new(trello_list)
      list.save
      Marshal.restore(Afterburn.redis.get("list:#{trello_list.id}")).should eq(trello_list)
    end
  end

  describe "fetch" do
    it "retrieves and saves trello list via api" do
      list = Afterburn::List.new(trello_list)
      new_trello_list = OpenStruct.new(:id => trello_list.id)
      Trello::List.should_receive(:find).with(list.id).and_return(new_trello_list)
      list.fetch
      list.trello_list.should eq(new_trello_list)
      Marshal.restore(Afterburn.redis.get("list:#{trello_list.id}")).should eq(new_trello_list)
    end

  end

end