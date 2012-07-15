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
    it "returns total count of cards on trello_list" do
      count = trello_list.cards.count
      list.load
      list.card_count.should eq(count)
    end
  end

  describe "flow_role" do
    it "can be 'backlog'" do
      list.flow_role = 'backlog'
      list.flow_role.should eq('backlog')
    end

    it "can be 'WIP'" do
      list.flow_role = 'WIP'
      list.flow_role.should eq('WIP')
    end

    it "can be 'deployed'" do
      list.flow_role = 'deployed'
      list.flow_role.should eq('deployed')
    end

    it "can be 'ignored'" do
      list.flow_role = 'ignored'
      list.flow_role.should eq('ignored')
    end

    it "raises an error if set to unknown role" do
      lambda { list.flow_role = 'foobar' }.should raise_error(Afterburn::List::UnknownFlowRole)
    end

    it "is persisted" do
      list.flow_role = 'backlog'
      new_list = Afterburn::List.new(list.id)
      new_list.flow_role.should eq('backlog')
    end
  end

end