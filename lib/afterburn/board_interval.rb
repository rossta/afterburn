require "base64"
require 'redis/objects'

module Afterburn
  class BoardInterval
    include RedisObjects

    attr_reader :board, :timestamp

    def self.find(id)
      board_id, timestamp_string = Base64.decode64(id).split(":")
      return nil if board_id.nil?
      new(Board.find(board_id), Time.at(timestamp_string.to_i))
    end

    def self.find_all(ids)
      ids.map { |interval_id| find(interval_id) }.compact
    end

    # TODO test
    def self.record(board, timestamp)
      new(board, timestamp).tap { |board_interval| board_interval.record! }
    end

    def initialize(board, timestamp = Time.now)
      @board = board
      @timestamp = timestamp
    end

    def id
      @id ||= Base64.encode64("#{@board.id}:#{@timestamp.to_i}")
    end

    def list_metrics
      @list_metrics ||= ListMetric.for_timestamp(@board.lists, timestamp)
    end

    def record!
      list_metrics.map(&:count!)
    end

    def ==(other)
      self.class == other.class && !other.id.nil? && self.id == other.id
    end

  end
end
