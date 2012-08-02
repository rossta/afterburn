require "spec_helper"

describe Afterburn::Project do
  let(:trello_board) { fetch_trello_board }
  let(:board) { Afterburn::Board.new(trello_board.id) }
  let(:project) { Afterburn::Project.new(board) }

  describe "#name" do
    it "uses board name by default" do
      project.name.should eq(board.name)
    end

    it "can store separate name" do
      project.name = "New Project"
      project.name.should eq("New Project")
    end
  end

  describe "#interval_set" do
    it "tracks timestamps in sorted order" do
      project.interval_set['a'] = 10
      project.interval_set['b'] = 100
      project.interval_set['c'] = 1

      project.interval_set[0..2].should == %w[c a b]
    end
  end

  describe "interval_series" do
    it "returns counts for deploy" do

    end
  end

end