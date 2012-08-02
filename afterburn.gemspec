$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "afterburn/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "afterburn"
  s.version     = Afterburn::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = "https://github.com/rossta/afterburn"
  s.summary     = "Cumulative flow diagrams for your Trello boards"
  s.description = "Keep tabs on cycle time for completing your work in progress based on your Trello lists"

  s.files = Dir["{lib,bin}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.executables << "burn"

  s.add_dependency "sinatra"
  s.add_dependency "redis-objects"
  s.add_dependency "ruby-trello"
  s.add_dependency "rack_csrf"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rails", "~> 3.2.6"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "vcr"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "launchy"

end
