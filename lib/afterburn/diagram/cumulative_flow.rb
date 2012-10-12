# Public: Displays a series of card totals for backlog lists, 
# individual work in progress lists, and completed lists by dates
module Afterburn
  module Diagram
    class CumulativeFlow < Series

      def series
        sum(project.backlog_lists, timestamps, :name => List::Role::BACKLOG) +
        map(project.wip_lists, timestamps) +
        sum(project.completed_lists, timestamps, :name => List::Role::COMPLETED)
      end

      def wip_series
        sum(project.wip_lists, timestamps)
      end

      # For each timestamp, find the time difference such that:
      # total completed (current) = total wip + completed (past)
      def lead_time_series
        
      end

    end
  end
end