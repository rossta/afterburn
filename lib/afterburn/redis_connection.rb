require 'redis'

module Afterburn
  module RedisConnection

    # Accepts:
    #   1. A 'hostname:port' String
    #   2. A 'hostname:port:db' String (to select the Redis db)
    #   3. A Redis URL String 'redis://host:port'
    #   4. An instance of `Redis`, `Redis::Client`, `Redis::DistRedis`
    def redis=(server)
      case server
      when String
        if server =~ /redis\:\/\//
          redis = Redis.connect(:url => server, :thread_safe => true)
        else
          host, port, db = server.split(':')
          redis = Redis.new(:host => host, :port => port,
            :thread_safe => true, :db => db)
        end

        @redis = redis
      else
        @redis = server
      end

      @redis
    end

    # Returns the current Redis connection. If none has been created, will
    # create a new one.
    def redis
      return @redis if @redis
      self.redis = Redis.respond_to?(:connect) ? Redis.connect : "localhost:6379"
      self.redis
    end

  end
end