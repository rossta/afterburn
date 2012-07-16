module Afterburn
  class List < TrelloObjectWrapper

    class UnknownFlowRole < StandardError; end
    module FlowRole
      extend self
      VALID_ROLES = [
        WIP         = 'WIP',      # work in progress
        BACKLOG     = 'backlog',
        DEPLOYED    = 'deployed',
        IGNORED     = 'ignored'
      ]

      def valid?(role)
        VALID_ROLES.include?(role)
      end
    end

    wrap :list
    value :flow_role_store
    set :historical_card_id_set
    set :metric_timestamp_list

    def flow_role=(role)
      raise UnknownFlowRole.new("Tried to set unrecognized '#{role}'") unless FlowRole.valid?(role)
      flow_role_store.value = role
    end

    def flow_role
      flow_role_store.value
    end

    def trello_cards
      trello_list.cards
    end

    def card_count
      trello_cards.count
    end

    def historical_card_ids
      historical_card_id_set.members
    end

    def historical_card_count
      historical_card_id_set.count
    end

    def update_historical_card_ids!
      trello_cards.map(&:id).each { |card_id| historical_card_id_set << card_id }
    end

  end
end