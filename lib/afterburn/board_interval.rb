require "base64"
require 'redis/objects'

module Afterburn
  class BoardInterval
    include RedisObjects

    attr_reader :board, :timestamp

    counter :lead_time
    counter :work_in_progress

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
      @timestamp = timestamp_for_interval(timestamp)
    end

    def id
      @id ||= Base64.encode64("#{@board.id}:#{@timestamp.to_i}")
    end

    def list_intervals
      @list_intervals ||= ListInterval.for_timestamp(@board.lists, timestamp)
    end

    def record!
      list_intervals.map(&:count!)
      # record lead time
      # record total work in progress
    end

    # def arrival_rate
    #   work_in_progress / lead_time
    # end

    def ==(other)
      self.class == other.class && !other.id.nil? && self.id == other.id
    end

  end
end
