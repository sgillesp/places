require 'places_configuration'
require 'tree'
require 'geocoder'

module Places
  class Place
    # Class declarations
    #
    # configuration
    #
    # !! note that configuration is class-wide, rather than on an
    #    instance-instance value; this could be changed, for example if
    #    two simultaneous persistence models for the place were desired
    #
    class << self
        attr_writer :configiration
    end

    def self.config
        @configuration ||= Configuration.new
    end

    def self.configure
        yield(config)
    end

    def self.reset
        @configuration = Configuration.new
    end

    case Place.config.use_tree_model
    when :mongoid_tree
    when :self
      include ::Mongoid::Document
      include Places::Tree

      # configure the way the tree behaves
      before_destroy :nullify_children
    else
      raise RuntimeErrror, 'Invalid option for Place.config.use_tree_model: #{Place.config.use_tree_model}'
    end

    # use geocoding?
    if Place.config.use_geocoder
        # geographical info
        field :coordinates, :type => Array

        # must come AFTER :coordinates field
        include Geocoder::Model::Mongoid
        geocoded_by :address
        after_validation    :geocode

        def latitude
            self.to_coordinates[0]
        end

        def longitude
            self.to_coordinates[1]
        end
    end

    field :name, type: String         # name of place
    field :description, type: String  # description
    #field :place_type, type: String, default: ->{ self.set_entity_type }  # type of entity (i.e. state, county, city, etc.)

    belongs_to :association # this is the associated object (i.e. campaign or user, if present)

    # need to have an address method (overloaded by subclasses)
    def address
        return self.name # default value, subclasses should override
    end

    # provide access to the entity type - subclasses should override
    def entity_type
        return 'place'
    end

    # don't want to index off of place name? - could have multiple entries w. similar names
    # create an index off of the place name, alone; will later create on off of the
    # geo locations *additionally*
    # index({ place_name: 1 }, { unique: false, name: "name_index"})

    # ** would like to hide these interfaces in a private/protected manner, not clear
    # ** how to do this in Ruby - doesn't have 'const' access similar to c++, etc.

    protected
        # subclasses should override to make sure the parent is appropriate for this child
        def is_valid_parent?(pa)
            return true
        end

        # check for validity, with adding error checking this would be the appropriate
        # place to add exceptions, etc. (to allow recovery)
        def is_valid_child?(ch)
            return ch.is_valid_parent?(self)
        end

        # called from is_valid_child, will raise an exception
        def invalid_child_error(ch)
          raise InvalidChild, "Cannot add #{ch.name} (#{ch.entity_type}) as child of #{self.name} (#{self.entity_type})"
        end

        # called from is_valid_parent, will raise and exception
        def invalid_parent_error(pa)
          raise InvalidParent, "Cannot add #{pa.name} (#{pa.enity_type}) as parent of #{self.name} (#{self.entity_type})"
        end

  end   # class Place
end # module Places
