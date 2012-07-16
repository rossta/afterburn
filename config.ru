#!/usr/bin/env ruby
require 'logger'

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'afterburn/server'

# Set the AFTERBURNCONFIG env variable if you've a `resque.rb` or similar
# config file you want loaded on boot.
if ENV['AFTERBURNCONFIG'] && ::File.exists?(::File.expand_path(ENV['AFTERBURNCONFIG']))
  load ::File.expand_path(ENV['AFTERBURNCONFIG'])
end

use Rack::ShowExceptions
use Rack::Session::Cookie, :secret => "some unique secret string here"
use Rack::Csrf, :raise => true

run Afterburn::Server.new