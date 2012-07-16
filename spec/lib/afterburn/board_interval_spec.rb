require "spec_helper"

describe Afterburn::BoardInterval do
  def fetch_trello_board
    Trello::Member.find('rossta').boards.first
  end

  let(:trello_board) { fetch_trello_board }
  let(:board) { Afterburn::Board.new(trello_board.id) }

  describe "self.find" do
    it "finds existing board interval" do
      now = Time.now
      instance_1 = Afterburn::BoardInterval.new(board, now)
      instance_2 = Afterburn::BoardInterval.find(instance_1.id)
      instance_2.should eq(instance_1)
    end
  end
end