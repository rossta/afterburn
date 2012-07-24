module Afterburn
  class List < TrelloObjectWrapper

    class UnknownRole < StandardError; end
    module Role
      extend self
      VALID_ROLES = [
        BACKLOG     = 'backlog',
        WIP         = 'WIP',      # work in progress
        DEPLOYED    = 'deployed',
        IGNORED     = 'ignored'
      ]

      HISTORICAL = [BACKLOG, DEPLOYED]

      def valid?(role)
        VALID_ROLES.include?(role)
      end

      def historical?(role)
        HISTORICAL.include?(role)
      end
    end

    wrap :list
    value :role_store
    set :historical_card_id_set
    set :metric_timestamp_list

    def self.roles
      Role::VALID_ROLES
    end

    def self.factory(trello_list)
      initialize_from_trello_object(trello_list).tap do |list|
        list.extend(History) if Role.historical?(list.role)
      end
    end

    def self.historical(list)
      HistoricalList.initialize_from_trello_object(list.trello_list)
    end

    def name
      trello_list.name
    end

    def role=(role)
      raise UnknownRole.new("Tried to set unrecognized '#{role}'") unless Role.valid?(role)
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

    def timestamp_count_vector(timestamps)
      ListMetric.timestamp_count_vector(self, timestamps)
    end

    def update_attributes(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
    end

    module History

      def card_count
        update_card_history
        historical_card_count  
      end

      def historical_card_ids
        historical_card_id_set.members
      end

      def historical_card_count
        historical_card_id_set.count
      end

      def update_card_history
        trello_cards.map(&:id).each { |card_id| historical_card_id_set << card_id }
      end

    end

  end

end