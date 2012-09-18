require 'spec_helper'

describe Afterburn::ListAggregation do
  module ListSpecHelper
    def stub_backlog_list
      stub(Afterburn::List,
        role: Afterburn::List::Role::BACKLOG,
        name: "backlog",
        :timestamp_count_vector => Vector[1, 2, 3])
    end

    def stub_wip_list
      stub(Afterburn::List,
        role: Afterburn::List::Role::WIP,
        name: "wip",
        :timestamp_count_vector => Vector[1, 2, 3])
    end

    def stub_completed_list
      stub(Afterburn::List, role:
        Afterburn::List::Role::COMPLETED,
        name: "completed",
        :timestamp_count_vector => Vector[1, 2, 3])
    end
  end
  include ListSpecHelper

  let(:lists) { [stub_backlog_list, stub_wip_list, stub_completed_list] }
  let(:timestamps) { [2.hours.ago, 1.hour.ago, Time.now] }

  let(:aggregation) { Afterburn::ListAggregation.new(lists, timestamps) }

  describe "#aggregate" do
    it "returns data as sum timestamp vectors from given lists" do
      vector = aggregation.aggregate(lists, :name => "test")
      first = vector.first
      first["name"].should eq("test")
      first["data"].should eq([3, 6, 9])
    end

    it "retrieves timestamp_count_vectors from lists" do
      lists.each do |list|
        list.should_receive(:timestamp_count_vector).with(timestamps)
      end

      aggregation.aggregate(lists, :name => "test")
    end
  end

  describe "#map" do
    it "returns data map of timestamp vectors from given lists" do
      vector = aggregation.map(lists)

      vector[0]["name"].should eq("backlog")
      vector[0]["data"].should eq([1,2,3])

      vector[1]["name"].should eq("wip")
      vector[1]["data"].should eq([1,2,3])

      vector[2]["name"].should eq("completed")
      vector[2]["data"].should eq([1,2,3])
    end

    it "retrieves timestamp_count_vectors from lists" do
      lists.each do |list|
        list.should_receive(:timestamp_count_vector).with(timestamps)
      end

      aggregation.map(lists)
    end
  end

end
