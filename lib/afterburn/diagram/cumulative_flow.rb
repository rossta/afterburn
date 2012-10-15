# Public: Displays a series of card totals for backlog lists, 
# individual work in progress lists, and completed lists by dates
module Afterburn
  module Diagram
    class CumulativeFlow < Series

      def param
        'cumulative-flow'
      end

      def series
        sum(backlog_lists, timestamps, :name => List::Role::BACKLOG) +
        map(wip_lists, timestamps) +
        sum(completed_lists, timestamps, :name => List::Role::COMPLETED)
      end

    end
  end
end