require 'spec_helper'

describe Afterburn::Diagram::CumulativeFlow do

  let(:project) { stub_project }
  subject { Afterburn::Diagram::CumulativeFlow.new(project) }

  it { subject.project.should eq(project) }

  describe "#series" do
    it "sums the backlog lists" do
      backlogs = subject.series.select { |hash| hash["name"] =~ /backlog/ }
      backlogs.size.should == 1

      backlog = backlogs.first
      backlog_vector_sum = Vector[1, 2, 3] + Vector[1, 2, 3]
      backlog["data"].should == backlog_vector_sum.to_a
    end

    it "aggregates the backlog lists" do
      wips = subject.series.select { |hash| hash["name"] =~ /wip/ }
      wips.size.should == 2

      wips.each do |wip|
        wip["data"].should == [1, 2, 3]
      end
    end

    it "sums the completed lists" do
      completes = subject.series.select { |hash| hash["name"] =~ /completed/ }
      completes.size.should == 1

      completed = completes.first
      completed_vector_sum = Vector[1, 2, 3] + Vector[1, 2, 3]
      completed["data"].should == completed_vector_sum.to_a
    end

  end

end