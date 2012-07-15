require "base64"

module Afterburn
  class ListMetric
    include Redis::Objects
    counter :cards

    def initialize(list, timestamp = Time.now)
      @list = list
      @timestamp = timestamp
    end

    def id
      @id ||= Base64.encode64("#{@list.id}:#{@timestamp.to_i}")
    end

    def count!
      cards.incr(@list.card_count)
    end

  end
end