module Afterburn
  class CumulativeFlowDiagram
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
      aggregation.sum(aggregation.backlog_lists, :name => List::Role::BACKLOG) +
      aggregation.map(aggregation.wip_lists) +
      aggregation.sum(aggregation.completed_lists, :name => List::Role::COMPLETED)
    end

    def aggregation
      @aggregation ||= ListAggregation.new(project.lists, project.interval_timestamps)
    end

  end
end