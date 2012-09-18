if Rails.env.test?
  Afterburn.redis = 'redis://localhost:9802'
end
Afterburn.redis = '127.0.0.1:6379/afterburn'
