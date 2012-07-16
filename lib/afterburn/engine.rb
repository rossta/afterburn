require 'afterburn'

module Afterburn
  class Engine < ::Rails::Engine
    isolate_namespace Afterburn

    initializer 'require_afterburn_server' do
      require 'afterburn/server'
    end
  end
end
