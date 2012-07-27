# desc "Explaining what the task does"
# task :afterburn do
#   # Task goes here
# end

namespace :afterburn do
  task :environment do
    require 'afterburn'
    config = ENV['AFTERBURNCONFIG'] || './lib/afterburn/server/config/setup.rb'
    load ::File.expand_path(config) if ::File.exists?(config)
  end

  desc "Record interval for current projects"
  task :record => :environment do
    Afterburn.current_projects.map(&:record_interval)
  end
end