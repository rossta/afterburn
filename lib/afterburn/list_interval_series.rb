require 'matrix'

# TODO test
module Afterburn
  class ListIntervalSeries
    def initialize(lists, timestamps)
      @lists, @timestamps = lists, timestamps
    end

    # deploy_list_counts + wip_list_counts + completed_list_counts
    def to_json
      aggregate(backlog_lists, :name => List::Role::BACKLOG) +
      map(wip_lists) +
      aggregate(deployed_lists, :name => List::Role::DEPLOYED)
    end

    def aggregate(lists, opts = {})
      vectors = lists.map { |list| list.timestamp_count_vector(@timestamps) }
      [{ "name" => opts[:name], "data" => vectors.inject(&:+).to_a }]
    end

    def map(lists)
      lists.map do |list|
        { "name" => list.name, "data" => list.timestamp_count_vector(@timestamps).to_a } 
      end
    end

    def backlog_lists
      @lists.select { |list| list.role == List::Role::BACKLOG }
    end

    def wip_lists
      @lists.select { |list| list.role == List::Role::WIP }
    end

    def deployed_lists
      @lists.select { |list| list.role == List::Role::DEPLOYED }
    end
  end

end