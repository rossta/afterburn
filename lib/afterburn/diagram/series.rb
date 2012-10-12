module Afterburn
  module Diagram
    class Series
      include ListAggregation

      attr_reader :project

      def initialize(project)
        @project = project
      end

      def to_json
        {}.tap do |hash|
          %w[ id name categories series ].each do |attribute| 
            hash[attribute] = send(attribute)
          end
        end.to_json
      end

      def id
        project.id
      end

      def name
        project.name
      end

      def categories
        project.interval_timestamps.map(&:end_of_day)  # not needed?
      end

      def series
        []
      end

      def timestamps
        project.interval_timestamps
      end
    end

  end
end
