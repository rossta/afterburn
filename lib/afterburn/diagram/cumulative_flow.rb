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

    end
  end
end