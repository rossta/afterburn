require "afterburn/engine"

module Afterburn
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :Helpers, "afterburn/helpers"
  autoload :Persistence, "afterburn/persistence"
  autoload :TrelloObjectWrapper, "afterburn/trello_object_wrapper"
  autoload :Board, "afterburn/board"
  autoload :Member, "afterburn/member"
  autoload :List, "afterburn/list"
  autoload :ListMetric, "afterburn/list_metric"

  extend RedisConnection
end
