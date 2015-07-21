require 'places_configuration.rb'

Place.configure do |config|
    config.use_tree_model = :mongoid_tree
    config.use_geocoder = :true
end