# Public: Displays a series of card totals for all work in progress by dates
module Afterburn
  module Diagram
    class WorkInProgress < Series

      def series
        sum(project.wip_lists, timestamps, :name => List::Role::WIP)
      end

    end
  end
end