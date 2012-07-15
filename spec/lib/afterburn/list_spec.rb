require 'spec_helper'
require 'ostruct'

describe Afterburn::List, :vcr, :record => :new_episodes do

  def fetch_trello_list
    Trello::Member.find('rossta').boards.first.lists.first
  end

  let(:trello_list) { fetch_trello_list }
  let(:list) { Afterburn::List.new(trello_list.id) }

  it { Afterburn::List.new(trello_list.id).id.should eq(trello_list.id) }

  describe "load" do
    it "fetches if trello list isn't stored" do
      list.should_receive(:fetch)
      list.load
    end

    it "retrieves from redis if previously fetched" do
      list.fetch

      list_2 = Afterburn::List.new(trello_list.id)
      list_2.should_not_receive(:fetch)
      list_2.load
    end
  end

  describe "fetch" do
    it "retrieves and saves trello list via api" do
      new_trello_list = OpenStruct.new(:id => trello_list.id)
      Trello::List.should_receive(:find).with(list.id).and_return(new_trello_list)
      list.fetch
      list.trello_list.should eq(new_trello_list)
    end
  end

  describe "#card_count" do
    it "returns total count of associated cards" do
      list.card_count.reset 2
      list.card_count.should eq(2)
    end
  end

  describe "#cumulative?" do
    it "is true if cumulative flag" do
      list.cumulative = true
      list.cumulative?.should be_true
    end

    it "is false" do
      list.cumulative = false
      list.cumulative?.should be_false
    end
  end

end