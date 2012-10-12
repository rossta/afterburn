require "spec_helper"

describe Afterburn::ListInterval, :vcr, :record => :new_episodes do
  let(:trello_list) { fetch_trello_list }
  let(:list) { Afterburn::List.new(trello_list.id) }

  it "persists card count" do
    list.stub!(:card_count => 3)
    list_interval = Afterburn::ListInterval.new(list)
    list_interval.count!
    list_interval.card_count.should eq(3)
  end
end