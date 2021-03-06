module Afterburn
  class Board < TrelloObjectWrapper
    wrap :board

    def self.fetch_by_member(member_name)
      Trello::Member.find(member_name).boards.map { |trello_board| initialize_from_trello_object(trello_board) }
    end

    def lists
      @lists ||= trello_lists.map { |trello_list| List.factory(trello_list) }
    end

    def trello_lists
      trello_board.lists
    end

    def name
      trello_board.name
    end

  end
end