require 'base64'
require 'matrix'
require 'redis/objects'

module Afterburn
  class ListMetric
    include RedisObjects

    attr_reader :list, :timestamp
    counter :card_count

    def self.for_timestamp(lists, timestamp)
      lists.map { |list| new(list, timestamp) }
    end

    def self.for_list(list, timestamps)
      timestamps.map { |timestamp| new(list, timestamp) }
    end

    # TODO test
    def self.timestamp_count_vector(list, timestamps)
      Vector[*for_list(list, timestamps).map { |metric| metric.card_count.to_i }]
    end

    def initialize(list, timestamp = Time.now)
      @list = list
      @timestamp = timestamp_for_interval(timestamp)
    end

    def id
      @id ||= Base64.encode64("#{@list.id}:#{@timestamp.to_i}")
    end

    def count!
      card_count.reset(@list.card_count)
    end

  end
end
