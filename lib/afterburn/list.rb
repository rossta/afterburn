module Afterburn
  class List < TrelloObjectWrapper
    wrap :list

    value :cumulative
    counter :card_count

    def cumulative?
      !!cumulative.value
    end

    def cumulative=(value)
      cumulative.value = value ? "true" : nil
    end
  end
end