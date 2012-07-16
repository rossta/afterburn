require 'afterburn'
require 'afterburn/server'

module Afterburn
  class Engine < ::Rails::Engine
    isolate_namespace Afterburn
  end
end
