# places_configuration.rb
#   hold configuration parameters for the library
#

module Places 
    class Configuration
        attr_accessor   :use_tree_model

    protected
        # initialize 
        def initialize
            @use_tree_model = :mongoid_tree
        end
    end
end