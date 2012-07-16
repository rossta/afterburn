require "afterburn/engine" if defined?(Rails)

module Afterburn
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :Helpers, "afterburn/helpers"
  autoload :TrelloObjectWrapper, "afterburn/trello_object_wrapper"
  autoload :Board, "afterburn/board"
  autoload :Member, "afterburn/member"
  autoload :List, "afterburn/list"
  autoload :ListMetric, "afterburn/list_metric"
  autoload :BoardInterval, "afterburn/board_interval"
  autoload :Project, "afterburn/project"

  extend RedisConnection
end
