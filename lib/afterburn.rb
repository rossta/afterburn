require 'trello'

module Afterburn
  autoload :Authorization, "afterburn/authorization"
  autoload :Board, "afterburn/board"
  autoload :BoardInterval, "afterburn/board_interval"
  autoload :Diagram, "afterburn/diagram"
  autoload :Helpers, "afterburn/helpers"
  autoload :List, "afterburn/list"
  autoload :ListMetric, "afterburn/list_metric"
  autoload :ListAggregation, "afterburn/list_aggregation"
  autoload :Member, "afterburn/member"
  autoload :Project, "afterburn/project"
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :RedisObjects, "afterburn/redis_objects"
  autoload :Server, "afterburn/server"
  autoload :TrelloObjectWrapper, "afterburn/trello_object_wrapper"

  extend RedisConnection
  extend self

  def authorize(member_name, &block)
    Authorization.new(member_name).configure(&block)
  end

  def current_member
    @current_member ||= Afterburn::Member.first
  end

  def current_projects
    Afterburn::Project.by_member(current_member)
  end

  def current_members
    Afterburn::Member.all
  end

  # TODO make configurable along with
  # other ActiveSupport time calculations, e.g.
  # beginning_of_day
  # beginning_of_week
  # beginning_of_month
  # end_of_day
  # end_of_week
  # end_of_month
  def timestamp_calculation_for_interval
    :end_of_day
  end

  class Bench
    def self.mark(msg, logger = Rails.logger)
      start = Time.now
      logger.info("#{start} --> starting #{msg} from #{caller[2]}:#{caller[1]}")
      result = yield
      finish = Time.now
      logger.info("#{finish} --< finished #{msg} --- #{"%2.3f sec" % (finish - start)}")
      result
    end
  end
end
