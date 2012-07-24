require 'trello'

module Afterburn
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :Helpers, "afterburn/helpers"
  autoload :TrelloObjectWrapper, "afterburn/trello_object_wrapper"
  autoload :Board, "afterburn/board"
  autoload :Member, "afterburn/member"
  autoload :List, "afterburn/list"
  autoload :ListMetric, "afterburn/list_metric"
  autoload :ListIntervalSeries, "afterburn/list_interval_series"
  autoload :BoardInterval, "afterburn/board_interval"
  autoload :Project, "afterburn/project"
  autoload :Authorization, "afterburn/authorization"
  autoload :Server, "afterburn/server"

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
end
