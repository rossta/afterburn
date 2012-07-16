require 'redis/objects'

module Afterburn
  class BoardInterval
    include Redis::Objects

    attr_reader :timestamp

    def self.find(id)
      board_id, timestamp = Base64.decode64(id).split(":")
      board = Board.find(board_id)
      new(board, timestamp)
    end

    def initialize(board, timestamp = Time.now)
      @board = board
      @timestamp = timestamp
    end

    def id
      @id ||= Base64.encode64("#{@board.id}:#{@timestamp.to_i}")
    end

    def list_metrics
      @list_metrics ||= @board.lists.map { |list| ListMetric.new(list, timestamp) }
    end

    def record!
raise "implement!"
    end

    def ==(other)
      self.class == other.class && !other.id.nil? && self.id == other.id
    end

  end
end