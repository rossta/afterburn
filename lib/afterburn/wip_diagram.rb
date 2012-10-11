module Afterburn
  class WIPDiagram
    include ListAggregation

    def initialize(project)
      @project = project
    end

    def to_json
      {}.tap do |hash|
        hash['id'] = project.id
        hash['name'] = project.name
        hash['categories'] = project.interval_timestamps.map(&:to_date)  # not needed?
        hash['series'] = wip_list_aggregation_json
      end.to_json
    end

    def wip_list_aggregation_json
      sum(project.wip_lists, timestamps, :name => List::Role::WIP)
    end

    def timestamps
      project.interval_timestamps
    end

  end
end