require 'matrix'

module Afterburn
  module ListAggregation

    def aggregate(lists, timestamps, opts = {})
      data = lists.map { |list| list.timestamp_count_vector(timestamps) }.inject(&:+).to_a
      [
        default_options(timestamps.first).merge({
          "name" => opts[:name],
          "data" => data
        })
      ]
    end
    alias :sum :aggregate

    def map(lists, timestamps, opts = {})
      lists.map do |list|
        default_options(timestamps.first).merge({
          "name" => opts[:name] || list.name,
          "data" => list.timestamp_count_vector(timestamps).to_a
        })
      end
    end

    def default_options(start_time)
      {
        "pointInterval" => one_day_in_milliseconds,
        "pointStart" => start_milliseconds(start_time)
      }
    end

    def start_milliseconds(start_time)
      start_time.to_i * 1000
    end

    def one_day_in_milliseconds
      24 * 3600 * 1000
    end

  end

end
