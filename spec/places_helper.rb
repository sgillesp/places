require 'places_configuration.rb'

Place.configure do |config|
    config.use_tree_model = :self
    config.use_geocoder = :false
end