#!/usr/bin/env ruby
require 'logger'

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'afterburn/server'

# Set the AFTERBURNCONFIG env variable if you've a `afterburn.rb` or similar
# config file you want loaded on boot.
config = ENV['AFTERBURNCONFIG'] || './lib/afterburn/server/config/setup.rb'
load ::File.expand_path(config) if ::File.exists?(config)

use Rack::ShowExceptions
use Rack::Session::Cookie, :secret => "some unique secret string here"
use Rack::Csrf, :raise => true

run Afterburn::Server.new