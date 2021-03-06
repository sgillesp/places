ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'places_helper'

Rails.backtrace_cleaner.remove_silencers!

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')

# this will cause factories to load twice!!
#Dir[File.join(ENGINE_RAILS_ROOT, "spec/factories/**/*.rb")].each {|f| require f}

# load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
    config.mock_with :rspec
    #config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
    config.infer_spec_type_from_file_location!

    config.include FactoryGirl::Syntax::Methods
    #config.include EngineControllerTestMonkeyPatch, :type => :controller
    config.before(:each, :type => :controller) { @routes = Places::Engine.routes }
    config.before(:each, :type => :routing)    { @routes = Places::Engine.routes }
    # !! may want to change this later - once specifics about exceptions from Place
    # !! are sorted out.
    RSpec::Expectations.configuration.warn_about_potential_false_positives = false
end



