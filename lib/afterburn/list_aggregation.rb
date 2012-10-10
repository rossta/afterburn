require 'matrix'

# TODO test
module Afterburn
  class ListAggregation
    def initialize(lists, timestamps)
      @lists, @timestamps = lists, timestamps
    end

    def to_json
      raise "implement in subclass"
    end

    def aggregate(lists, opts = {})
      data = lists.map { |list| list.timestamp_count_vector(@timestamps) }.inject(&:+).to_a
      [
        default_options.merge({
          "name" => opts[:name],
          "data" => data
        })
      ]
    end
    alias :sum :aggregate

    def map(lists, opts = {})
      lists.map do |list|
        default_options.merge({
          "name" => opts[:name] || list.name,
          "data" => list.timestamp_count_vector(@timestamps).to_a
        })
      end
    end

    def default_options
      {
        "pointInterval" => one_day_in_milliseconds,
        "pointStart" => start_milliseconds
      }
    end

    def backlog_lists
      @lists.select { |list| list.role == List::Role::BACKLOG }
    end

    def wip_lists
      @lists.select { |list| list.role == List::Role::WIP }
    end

    def completed_lists
      @lists.select { |list| list.role == List::Role::COMPLETED }
    end

    def start_milliseconds
      @timestamps.first.to_i * 1000
    end

    def one_day_in_milliseconds
      24 * 3600 * 1000
    end
  end

end
