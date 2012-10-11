module Afterburn
  class CumulativeFlowDiagram
    include ListAggregation

    attr_reader :project
    
    def initialize(project)
      @project = project
    end

    def to_json
      {}.tap do |hash|
        hash['id'] = project.id
        hash['name'] = project.name
        hash['categories'] = project.interval_timestamps.map(&:to_date)  # not needed?
        hash['series'] = cumulative_flow_list_aggregation_json
      end.to_json
    end

    def cumulative_flow_list_aggregation_json
      sum(project.backlog_lists, timestamps, :name => List::Role::BACKLOG) +
      map(project.wip_lists, timestamps) +
      sum(project.completed_lists, timestamps, :name => List::Role::COMPLETED)
    end

    def timestamps
      project.interval_timestamps
    end

  end
end