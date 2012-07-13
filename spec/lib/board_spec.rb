require 'spec_helper'
require 'ostruct'

describe Afterburn::Board, :vcr, :record => :new_episodes do
  def fetch_trello_board
    Afterburn::Board.fetch_by_member('rossta').first
  end

  let(:trello_board) { fetch_trello_board }

  describe "self.fetch_by_member" do
    it "should retrieve boards for given member" do
      boards = Afterburn::Board.fetch_by_member('rossta')
      board_names = boards.map(&:name)
      board_names.should include("Platform")
    end
  end

  describe "self.save" do
    it "should persist trello board" do
      Afterburn::Board.save(trello_board)
      Trello::Board.should_not_receive(:find)
      loaded_board = Afterburn::Board.find(trello_board.id)
      loaded_board.trello_board.should eq(trello_board)
    end
  end

  describe "self.find" do
    it "should get board via api and marshal result if not found in redis" do
      Afterburn.redis.get("board:#{trello_board.id}").should be_nil
      board = Afterburn::Board.find(trello_board.id)
      board.trello_board.should eq(trello_board)
      Marshal.restore(Afterburn.redis.get("board:#{trello_board.id}")).should eq(trello_board)
    end

    it "should get load marshaled board result if found in redis" do
      Afterburn::Board.find(trello_board.id)
      Trello::Board.should_not_receive(:find)
      board = Afterburn::Board.find(trello_board.id)
      board.trello_board.should eq(trello_board)
    end
  end

  it { Afterburn::Board.new(trello_board).id.should eq(trello_board.id) }

  describe "save" do
    it "marshals trello board in redis" do
      Afterburn.redis.get("board:#{trello_board.id}").should be_nil
      board = Afterburn::Board.new(trello_board)
      board.save
      Marshal.restore(Afterburn.redis.get("board:#{trello_board.id}")).should eq(trello_board)
    end
  end

  describe "sync" do
    it "retrieves and saves trello board via api" do
      board = Afterburn::Board.new(trello_board)
      new_trello_board = OpenStruct.new(:id => trello_board.id)
      Trello::Board.should_receive(:find).with(board.id).and_return(new_trello_board)
      board.sync
      board.trello_board.should eq(new_trello_board)
      Marshal.restore(Afterburn.redis.get("board:#{trello_board.id}")).should eq(new_trello_board)
    end

  end

end