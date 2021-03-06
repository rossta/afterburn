# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["AFTERBURN_REDIS_URL"] ||= 'localhost:9802'

require 'redis_spec_server'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

puts Afterburn.redis.inspect

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:each) do
    Afterburn.flush_redis
  end
end

# require 'capybara-webkit'
# Capybara.javascript_driver = :webkit
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
