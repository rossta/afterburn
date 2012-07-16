require 'redis/objects'

module Afterburn
  class Project
    include Redis::Objects

    value :redis_name_value
    sorted_set :interval_set

    attr_reader :id

    def self.for_member(member_name)
      Board.fetch_by_member(member_name).map { |board| Project.new(board) }
    end

    def initialize(board)
      @board = board
    end

    def id
      @id ||= @board.id
    end

    def name=(name)
      redis_name_value.value = name
    end

    def name
      redis_name_value.value || @board.name
    end

    def lists
      @board.lists
    end

    def record_interval
      timestamp = Time.now
      BoardInterval.new(@board, timestamp).tap do |interval|
        interval.record!
        interval_set[interval.id] = timestamp.to_i
      end
    end

    def intervals
      @intervals ||= interval_set.members.map { |interval_id| BoardInterval.find(interval_id) }
    end

    def to_json
      {}.tap do |hash|
        hash['id'] = id
        hash['name'] = name
        hash['categories'] = interval_timestamps.map(&:to_date)
        hash['series'] = interval_series
      end
    end

    def interval_timestamps
      intervals.map(&:timestamp)
    end

    def interval_series
      lists.map do |list|
        { "name" => list.name, "data" => list.card_counts_for_timestamps(interval_timestamps) }
      end     
    end

  end
end