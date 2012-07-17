module Afterburn
  class List < TrelloObjectWrapper

    class UnknownFlowRole < StandardError; end
    module FlowRole
      extend self
      VALID_ROLES = [
        BACKLOG     = 'backlog',
        WIP         = 'WIP',      # work in progress
        DEPLOYED    = 'deployed',
        IGNORED     = 'ignored'
      ]

      def valid?(role)
        VALID_ROLES.include?(role)
      end
    end

    wrap :list
    value :role_store
    set :historical_card_id_set
    set :metric_timestamp_list

    def self.roles
      FlowRole::VALID_ROLES
    end

    def name
      trello_list.name
    end

    def role=(role)
      raise UnknownFlowRole.new("Tried to set unrecognized '#{role}'") unless FlowRole.valid?(role)
      role_store.value = role
    end

    def role
      role_store.value
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

    def card_counts_for_timestamps(timestamps)
      timestamps.map { |timestamp| ListMetric.new(self, timestamp).card_count.to_i }
    end

    def update_attributes(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end

  end
end