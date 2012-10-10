require 'afterburn'
require 'redis/objects'

module Afterburn
  class Project
    include RedisObjects

    value :redis_name_value
    value :enabled_value
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

    attr_reader :board
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

    def enable!
      enabled_value.value = "1"
    end

    def disable!
      enabled_value.value = nil
    end

    def enable=(enabled)
      enabled == "1" ? enable! : disable!
    end

    def enabled?
      !!enabled_value.value
    end

    def lists
      @board.lists
    end

    # TODO test
    def record_interval(timestamp = Time.now)
      interval = BoardInterval.record(@board, timestamp)
      interval_set[interval.id] = timestamp.to_i
      timestamp
    end

    # TODO handle BoardIntervals not found
    def intervals
      @intervals ||= BoardInterval.find_all(interval_set.members)
    end

    def interval_timestamps
      intervals.map(&:timestamp)
    end

    def cumulative_flow_diagram
      CumulativeFlowDiagram.new(self)
    end

    def update_attributes(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end

  end
end
