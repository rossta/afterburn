if Rails.env.test?
  Afterburn.redis = 'redis://localhost:9802'
end
Redis.current = Afterburn.redis