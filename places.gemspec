$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "places/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "places"
  s.version     = Places::VERSION
  s.authors     = ["sgillesp"]
  s.email       = ["masterofratios@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Places engine for the CSC application."
  s.description = "Handles a tree of objects with reciprocal references and associated geo-location data."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2.3"
  s.add_dependency "mongodb"
  s.add_dependency "moped"
  s.add_dependency "mongoid"
  s.add_dependency "bson_ext"
  s.add_dependency "geocoder"

  s.add_development_dependency "rspec-rails", "3.3.2"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "faker"
  s.add_development_dependency "better_errors"
  s.add_development_dependency "binding_of_caller"
end
