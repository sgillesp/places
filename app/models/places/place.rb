require 'places_configuration'
require 'mongoid/tree'
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
    # handle configuration specific inclusions
    case Place.config.use_tree_model
        when :mongoid_tree
            include ::Mongoid::Document
            include ::Mongoid::Tree

            # try to establish validations
            validates_associated :parent, :children

            # set policy for handling destroying of a root
            before_destroy :nullify_children
        else
            # what is needed for the home-grown model
            include ::Mongoid::Document

            has_many :children, class_name: "Places::Place"  # places within this place
            belongs_to :parent, class_name: "Places::Place", dependent: :nullify  # places containing this place 
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
    #field :entity_type, type: String, default: ->{ self.do_init }  # type of entity (i.e. state, county, city, etc.)

    belongs_to :association # this is the associated object (i.e. campaign or user, if present)

    # need to have an address method (overloaded by subclasses)
    def address
        return self.name # default value, subclasses should override
    end

    # shouldn't have to do all of this; try to use validation

    def remove_parent
         # has to go from parent to child
         self.parent.remove_child(self)
    end

    #def set_parent (pa)
    #     self.parent = pa 
    #     # validate for a circular reference
    #     par = pa
    #     while par != nil do
    #         if par == self
    #             raise ArgumentError.new("Circular references not allowed.")    # throw an exceptino - can't have circular reference
    #         end
    #         par = par.parent
    #     end 
    # end

    # def add_child (ch)
    #     # do not allow adding nil ch == nil || ch == self
    #     if is_valid_child(ch)
    #         self.children << ch
    #         ch.set_parent(self)
    #     else
    #         # throw exception for invalid child
    #         # !! for now use argument error until this is fleshed out
    #         raise ArgumentError, "#{ch.entity_type}: #{ch.name} is an invalid child of #{entity_type}: #{self.name}"
    #     end
    # end

    # def remove_child (ch)
    #     # does no error check here!!
    #     unless ch == nil
    #         # this should automatically remove the parent
    #         self.children.delete(ch)
    #     end
    # end

    # don't want to index off of place name? - could have multiple entries w. similar names
    # create an index off of the place name, alone; will later create on off of the
    # geo locations *additionally*
    # index({ place_name: 1 }, { unique: false, name: "name_index"})

    # ** would like to hide these interfaces in a private/protected manner, not clear 
    # ** how to do this in Ruby - doesn't have 'const' access similar to c++, etc. 

    # provide access to the entity type - subclasses should override
    def entity_type
        return 'place'
    end

    # def do_init
    #     @entity_type = 'base'
    # end

    # protected
    #     # sublcasses should override to make sure this child is appropriate
    #     def validate_child(ch)
    #         # does nothing else
    #         return ch.is_valid_parent(self)
    #     end 

    protected
        # subclasses should override to make sure the parent is appropriate for this child
        def is_valid_parent(pa)
            return true
        end

        # check for validity, with adding error checking this would be the appropriate
        # place to add exceptions, etc. (to allow recovery)
        def is_valid_child(ch)
            return true
            #return ((ch != nil) && (ch != self)) && validate_child(ch)
        end


        def validate_child (ch)
            if ((ch == nil) || (ch == self)) || !is_valid_child(ch)
                # throw exception for invalid child
                # !! for now use argument error until this is fleshed out
                raise ArgumentError, "#{ch.entity_type}: #{ch.name} is an invalid child of #{entity_type}: #{self.name}"
            else 
                ch.validate_parent(self) # this will throw exception as well
                # doesn't yet check for circular reference
            end
        end

        def validate_parent (pa)
            par = pa
            while par != nil do
                unless self.is_valid_parent(pa)
                    raise ArgumentError.new("Circular references not allowed; cannot add #{pa} as parent to #{self}")
                end
                par = par.parent
            end
        end

    private # these declarations are private to avoid someone messign with the underlying representation

  end   # class Place
end # module Places
