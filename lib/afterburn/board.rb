require "trello"

module Afterburn
  class Board
    extend Persistence
    include Persistence

    def self.fetch_by_member(member_name)
      Trello::Member.find(member_name).boards
    end

    def self.all_by_member(member_name)
      redis.get("boards:#{member_name}")
    end

    def self.sync_by_member(member_name)
      fetch_by_member(member_name).map { |trello_board| save(trello_board) }
    end

    def self.save(trello_board)
      new(trello_board).save
    end

    def self.find(id)
      if marshaled_trello_board = redis.get("board:#{id}")
        new(marshal_load(marshaled_trello_board))
      else
        save(Trello::Board.find(id))
      end
    end

    attr_reader :trello_board

    def initialize(trello_board)
      @trello_board = trello_board
    end

    def id
      @trello_board.id
    end

    def save
      redis.set("board:#{id}", marshal_dump(@trello_board))
      self
    end

    def sync
      @trello_board = Trello::Board.find(id)
      save
    end

  end
end