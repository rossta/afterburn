module Afterburn
  class Project
    include Redis::Objects

    value :redis_name_value
    sorted_set :interval_set

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

    def record
      Time.now.tap do |timestamp|
        interval = BoardInterval.new(@board, timestamp)
        interval.record!
        interval_set[interval.id] = timestamp
      end
    end

  end
end