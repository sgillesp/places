module Places
  class Place
    include ::Mongoid::Document
    include ::Mongoid::Attributes::Dynamic

    # this uses a Factory pattern to insanciate the Places; this, 
    # hopefully, will allow enforcement of the appropriate hierarchy and 
    # connections
    # class << self
    #     def create_place ()
    #         p = new
    #         @s_place_root ||= p
    #         return p
    #     end

    #     def root
    #         return @s_place_root
    #     end
          
    #     private :new
    # end
    # public
    # data fields for this class
    field :place_name, type: String         # name of place
    field :place_description, type: String  # description

    # relationships to other places/objects; each place may have multiple child
    # places. If the parent place is deleted, then an error is raised as the children
    # would be orphaned - this can be handled later. If the child is deleted, the parent-child
    # relationship (with the parent of this object) is nullified.  
    has_many :children   # places within this place
    belongs_to :parent   # places containing this place 
    
    has_one :association # this is the associated object (i.e. campaign or user, if present)

    # create an index off of the place name, alone; will later create on off of the
    # geo locations *additionally*
    index({ place_name: 1 }, { unique: false, name: "name_index"})

    # to_param method for 
    def to_param
        @place_name
    end

    protected

        # wrap up initialization after new called;
        def initialize ()
          # for now simply assign the asssociation, need to add     
          # hierarchical structuring to enforce the appropriate tree
          # structure
          # if assoc
          #     @association = assoc
          #     @association.assign_place(self)
          #     if (@association.respond_to?(:name))
          #         @place_name = @association.name
          #     end
          # end
          @place_name = "funk"
          @place_description = "really funk"
        end

    private
        # class variable - root of a place; this will deprecate but is useful for testing
        @@s_place_root = nil
          
  end   # class Place
end # module Places
