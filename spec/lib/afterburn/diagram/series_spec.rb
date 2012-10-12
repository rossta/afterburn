require 'spec_helper'

describe Afterburn::Diagram::Series do
  let(:project) { stub_project }
  let(:series) { Afterburn::Diagram::Series.new(project) }
  
  it "returns json" do
    json = JSON.parse(series.to_json)
    json['id'].should_not be_blank
    json['id'].should eq(project.id)
    json['name'].should eq(project.name)
    json['categories'].should eq(JSON.parse(project.interval_timestamps.map(&:end_of_day).to_json))
    json['series'].should be_empty
  end
end