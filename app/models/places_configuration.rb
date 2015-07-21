# places_configuration.rb
#   hold configuration parameters for the library
#

module Places
    class Configuration
        attr_accessor   :use_tree_model
        attr_accessor   :use_geocoder

    protected
        # initialize
        def initialize
            @use_tree_model = :self
            @use_geocoder = :true
        end
    end
end
