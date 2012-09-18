# including this module provides helpers for Redis::Objects
# and ensures the redis handle is scope to Afterburn
module Afterburn
  module RedisObjects

    def redis
      Afterburn.redis
    end

    def timestamp_for_interval(timestamp)
      timestamp.send(Afterburn.timestamp_calculation_for_interval)
    end

    def self.included(base)
      super
      base.send :include, Redis::Objects
      base.extend self
    end
  end
end
