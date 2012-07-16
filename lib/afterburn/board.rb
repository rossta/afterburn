module Afterburn
  class Board < TrelloObjectWrapper
    wrap :board

    delegate :name, :to => :trello_board

    def self.fetch_by_member(member_name)
      Trello::Member.find(member_name).boards.map { |trello_board| initialize_from_trello_object(trello_board) }
    end

    def lists
      @lists ||= trello_lists.map { |trello_list| List.initialize_from_trello_object(trello_list) }
    end

    def trello_lists
      trello_board.lists
    end

  end
end