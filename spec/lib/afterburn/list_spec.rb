require 'spec_helper'
require 'ostruct'

describe Afterburn::List, :vcr, :record => :new_episodes do
  let(:trello_list) { fetch_trello_list }
  let(:list) { Afterburn::List.new(trello_list.id) }

  it { Afterburn::List.new(trello_list.id).id.should eq(trello_list.id) }

  describe "self.factory" do
    it "should return an afterburn list linked to a given trello_list" do
      list = Afterburn::List.factory(trello_list)
      list.should be_a(Afterburn::List)
      list.trello_list.should eq(trello_list)
    end

    it "includes history behavior is role is historical" do
      Afterburn::List::Role.should_receive(:historical?).and_return(true)
      list = Afterburn::List.factory(trello_list)
      list.respond_to?(:historical_card_ids).should be_true
    end

    it "does not include history behavior otherwise" do
      Afterburn::List::Role.should_receive(:historical?).and_return(false)
      list = Afterburn::List.factory(trello_list)
      list.respond_to?(:historical_card_ids).should be_false
    end
  end

  describe "load" do
    it "fetches if trello list isn't stored" do
      list.trello_object_store.value = nil
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

  describe "role" do
    it "can be 'backlog'" do
      list.role = 'backlog'
      list.role.should eq('backlog')
    end

    it "can be 'WIP'" do
      list.role = 'WIP'
      list.role.should eq('WIP')
    end

    it "can be 'deployed'" do
      list.role = 'deployed'
      list.role.should eq('deployed')
    end

    it "can be 'ignored'" do
      list.role = 'ignored'
      list.role.should eq('ignored')
    end

    it "raises an error if set to unknown role" do
      lambda { list.role = 'foobar' }.should raise_error(Afterburn::List::UnknownRole)
    end

    it "is persisted" do
      list.role = 'backlog'
      new_list = Afterburn::List.new(list.id)
      new_list.role.should eq('backlog')
    end
  end

  describe "Historical List" do
    before do
      list.extend(Afterburn::List::History)
    end

    describe "#historical_card_ids" do
      it "starts empty" do
        list.historical_card_ids.should be_empty
      end

      it "lists of current cards ids after update" do
        list.update_card_history
        list.historical_card_ids.should include(list.trello_cards.first.id)
      end

      it "lists of previous cards ids after update" do
        list.historical_card_id_set << "12345"
        list.update_card_history
        list.historical_card_ids.should include("12345")
        list.historical_card_ids.should include(list.trello_cards.first.id)
      end

      it "is persisted" do
        list.update_card_history
        new_list = Afterburn::List.new(list.id)
        new_list.extend(Afterburn::List::History)
        new_list.historical_card_ids.should include(list.trello_cards.first.id)
      end
    end

    describe "#historical_card_count" do
      it "starts at 0" do
        list.historical_card_count.should eq(0)
      end

      it "returns count of historical_card_ids" do
        list.historical_card_id_set << "12345"
        list.historical_card_count.should eq(1)
      end
    end

  end
end