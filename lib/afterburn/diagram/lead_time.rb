# Public: Displays a series of card totals for all work in progress by dates
module Afterburn
  module Diagram
    class LeadTime < Series

      def param
        'lead-time'
      end
      
      def series
        sum(project.wip_lists, timestamps, :name => List::Role::WIP)
      end

    end
  end
end