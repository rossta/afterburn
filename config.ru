#!/usr/bin/env ruby
require 'logger'

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'afterburn/server'

# Set the AFTERBURNCONFIG env variable if you've a `afterburn.rb` or similar
# config file you want loaded on boot.
config = ENV['AFTERBURNCONFIG']
if config && ::File.exists?(config)
  load ::File.expand_path(config)
else
  #
  # 1. Get your trello key and secret:
  # => https://trello.com/1/appKey/generate.
  # 2. Generate an app token for afterburn:
  # => https://trello.com/1/connect?key=PUBLIC_KEY_FROM_ABOVE&name=MyApp&response_type=token&scope=read,write,account&expiration=never
  # 3. Set up the required environment variables:

  Afterburn.authorize ENV['TRELLO_USER_NAME'] do |auth|
    auth.trello_user_key = ENV['TRELLO_USER_KEY']
    auth.trello_user_secret = ENV['TRELLO_USER_SECRET']
    auth.trello_app_token = ENV['TRELLO_APP_TOKEN']
  end
end

use Rack::ShowExceptions
use Rack::Session::Cookie, :secret => "some unique secret string here"
use Rack::Csrf, :raise => true

run Afterburn::Server.new
