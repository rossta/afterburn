require 'redis/objects'

module Afterburn
  class Project
    include Redis::Objects

    value :redis_name_value
    sorted_set :interval_set

    def self.for_member(member_name)
      Board.fetch_by_member(member_name).map { |board| Project.new(board) }
    end

    def initialize(board)
      @board = board
    end

    def id
      @board.id
    end

    def name=(name)
      redis_name_value.value = name
    end

    def name
      redis_name_value.value || @board.name
    end

    def record_interval
      timestamp = Time.now
      BoardInterval.new(@board, timestamp).tap do |interval|
        interval.record!
        interval_set[interval.id] = timestamp.to_i
      end
    end

  end
end