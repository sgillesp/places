# places_configuration.rb
#   hold configuration parameters for the library
#

module Places
    class Configuration
        attr_accessor   :use_tree_model
        attr_accessor   :use_geocoder
        attr_accessor   :google_api_key

    protected
        # initialize
        def initialize
            @use_tree_model = :self
            @use_geocoder = :true
            @google_api_key = 'AIzaSyDR-WjFAX-6lYkLBparpdxrXiFsHet-DQY'
        end
    end
end
