module Afterburn
  class Board < TrelloObjectWrapper
    wrap :board

    def self.fetch_by_member(member_name)
      Trello::Member.find(member_name).boards
    end

    def self.all_by_member(member_name)
      redis.get("boards:#{member_name}")
    end

    def self.sync_by_member(member_name)
      fetch_by_member(member_name).map { |trello_board| save(trello_board) }
    end

  end
end