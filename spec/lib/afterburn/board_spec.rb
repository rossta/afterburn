require 'spec_helper'
require 'ostruct'

describe Afterburn::Board, :vcr, :record => :new_episodes do
  let(:trello_board) { fetch_trello_board }
  let(:board) { Afterburn::Board.new(trello_board.id) }

  it { Afterburn::Board.new(trello_board.id).id.should eq(trello_board.id) }

  describe "self.fetch_by_member" do
    it "should retrieve trello boards for given member" do
      boards = Afterburn::Board.fetch_by_member('tech1')
      board_names = boards.map(&:name)
      board_names.should include("Platform")
    end

    it "should initialize afterburn boards" do
      boards = Afterburn::Board.fetch_by_member('tech1')
      boards.first.should be_a(Afterburn::Board)
    end
  end

  describe "load" do
    it "fetches if trello board isn't stored" do
      board.trello_object_store.value = nil
      board.should_receive(:fetch)
      board.load
    end

    it "retrieves from redis if previously fetched" do
      board.fetch

      board_2 = Afterburn::Board.new(trello_board.id)
      board_2.should_not_receive(:fetch)
      board_2.load
    end
  end

  describe "fetch" do
    it "retrieves and saves trello board via api" do
      new_trello_board = OpenStruct.new(:id => trello_board.id)
      Trello::Board.should_receive(:find).with(board.id).and_return(new_trello_board)
      board.fetch
      board.trello_board.should eq(new_trello_board)
    end
  end
end