$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "afterburn/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "afterburn"
  s.version     = Afterburn::VERSION
  s.authors     = ["Ross Kaffenberger"]
  s.email       = ["rosskaff@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Afterburn."
  s.description = "TODO: Description of Afterburn."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "redis-namespace"
  s.add_dependency "redis-objects"
  s.add_dependency "ruby-trello"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "vcr"
  s.add_development_dependency "fakeweb"

end
