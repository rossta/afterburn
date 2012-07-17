require 'afterburn'
require 'redis/objects'

module Afterburn
  class Project
    include Redis::Objects

    value :redis_name_value
    sorted_set :interval_set

    attr_reader :id

    def self.by_member_name(member_name)
      Board.fetch_by_member(member_name).map { |board| Project.new(board) }
    end

    def self.by_member(member)
      member.boards.map { |board| Project.new(board) }
    end

    def self.find(id)
      new(Board.find(id))
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

    # TODO handle BoardIntervals not found
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