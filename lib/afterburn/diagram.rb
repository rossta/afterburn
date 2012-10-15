module Afterburn
  module Diagram
    extend self

    autoload :Series, 'afterburn/diagram/series'
    autoload :CumulativeFlow, 'afterburn/diagram/cumulative_flow'
    autoload :LeadTime, 'afterburn/diagram/lead_time'

    def build(project, opts = {})
      case opts[:type]
      when 'lead-time'
        LeadTime.new(project)
      when 'cycle-time'
        # CycleTime.new(project)
      when 'throughput'
        # Throughput.new(project)
      else # 'cumulative-flow'
        CumulativeFlow.new(project)
      end
    end

  end
end