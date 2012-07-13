require "afterburn/engine"

module Afterburn
  autoload :RedisConnection, "afterburn/redis_connection"
  autoload :Helpers, "afterburn/helpers"
  autoload :Persistence, "afterburn/persistence"
  autoload :ApiWrapper, "afterburn/api_wrapper"
  autoload :Board, "afterburn/board"
  autoload :Member, "afterburn/member"
  autoload :List, "afterburn/list"

  extend RedisConnection
end
