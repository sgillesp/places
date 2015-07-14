ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb")
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'
require 'rails/mongoid'

Rails.backtrace_cleaner.remove_silencers!

# load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
end

