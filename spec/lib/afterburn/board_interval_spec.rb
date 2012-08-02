require "spec_helper"

describe Afterburn::BoardInterval do
  let(:trello_board) { fetch_trello_board }
  let(:board) { Afterburn::Board.new(trello_board.id) }
  let(:now) { Time.now }
  let(:interval) { Afterburn::BoardInterval.new(board, now) }

  describe "self.find" do
    it "finds existing board interval" do
      instance_1 = Afterburn::BoardInterval.new(board, now)
      instance_2 = Afterburn::BoardInterval.find(instance_1.id)
      instance_2.should eq(instance_1)
    end
  end

  describe "self.find_all" do
    it "finds existing board for each ids" do
      intervals = Afterburn::BoardInterval.find_all [interval.id]
      intervals.should eq([interval])
    end

    it "removes nils" do
      intervals = Afterburn::BoardInterval.find_all ["abc", interval.id, "123"]
      intervals.should eq([interval])
    end
  end
end