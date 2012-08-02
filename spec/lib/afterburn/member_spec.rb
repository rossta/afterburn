require 'spec_helper'
require 'ostruct'

describe Afterburn::Member, :vcr, :record => :new_episodes do
  let(:trello_member) { fetch_trello_member }
  let(:member) { Afterburn::Member.new(trello_member.id) }

  it { Afterburn::Member.new(trello_member.id).id.should eq(trello_member.id) }

  describe "load" do
    it "fetches if trello member isn't stored" do
      member.should_receive(:fetch)
      member.load
    end

    it "retrieves from redis if previously fetched" do
      member.fetch

      member_2 = Afterburn::Member.new(trello_member.id)
      member_2.should_not_receive(:fetch)
      member_2.load
    end
  end

  describe "fetch" do
    it "retrieves and saves trello member via api" do
      new_trello_member = OpenStruct.new(:id => trello_member.id)
      Trello::Member.should_receive(:find).with(member.id).and_return(new_trello_member)
      member.fetch
      member.trello_member.should eq(new_trello_member)
    end
  end
end