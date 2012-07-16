require "base64"
require 'redis/objects'

module Afterburn
  class ListMetric
    include Redis::Objects

    attr_reader :timestamp
    counter :card_count

    def initialize(list, timestamp = Time.now)
      @list = list
      @timestamp = timestamp
    end

    def id
      @id ||= Base64.encode64("#{@list.id}:#{@timestamp.to_i}")
    end

    def count!
      card_count.incr(@list.card_count)
    end

  end
end