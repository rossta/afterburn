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

    def flow_role=(role)
      raise UnknownFlowRole.new("Tried to set unrecognized '#{role}'") unless FlowRole.valid?(role)
      flow_role_store.value = role
    end

    def flow_role
      flow_role_store.value
    end

    def card_count
      trello_list.cards.count
    end

  end
end