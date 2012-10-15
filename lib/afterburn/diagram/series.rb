module Afterburn
  module Diagram
    class Series
      include ListAggregation

      attr_reader :project

      delegate :id, :name, to: :project
      delegate :backlog_lists, :wip_lists, :completed_lists, to: :project

      def initialize(project)
        @project = project
      end

      def to_json
        {}.tap do |hash|
          hash['diagramType'] = param
          %w[ id name categories series ].each do |attribute| 
            hash[attribute] = send(attribute)
          end
        end.to_json
      end

       def categories
        timestamps.map(&:end_of_day)  # not needed?
      end

      def series
        []
      end

      def timestamps
        project.interval_timestamps
      end

      def param
        'series'
      end

    end

  end
end
