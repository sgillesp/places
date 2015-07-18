module Places
  class Place
    include ::Mongoid::Document

    field :name, type: String         # name of place
    field :description, type: String  # description

    # has_one :association # this is the associated object (i.e. campaign or user, if present)
    
    def remove_parent
        # has to go from parent to child
        self.parent.remove_child(self)
    end

    def set_parent (pa)
        self.parent = pa 
        # validate for a circular reference
        par = pa
        while par != nil do
            if par == self
                raise ArgumentError.new("Circular references not allowed.")    # throw an exceptino - can't have circular reference
            end
            par = par.parent
        end 
    end

    def add_child (ch)
        # do not allow adding nil class, do not allow circular ref
        unless ch == nil || ch == self
            self.children << ch
        end
        ch.set_parent(self)
    end

    def remove_child (ch)
        # does no error check here!!
        unless ch == nil
            # this should automatically remove the parent
            self.children.delete(ch)
        end
    end

    # don't want to index off of place name? - could have multiple entries w. similar names
    # create an index off of the place name, alone; will later create on off of the
    # geo locations *additionally*
    # index({ place_name: 1 }, { unique: false, name: "name_index"})

    # ** would like to hide these interfaces in a private/protected manner, not clear 
    # ** how to do this in Ruby - doesn't have 'const' access similar to c++, etc. 

    # relationships to other places/objects; each place may have multiple child
    # places. If the parent place is deleted, then an error is raised as the children
    # would be orphaned - this can be handled later. If the child is deleted, the parent-child
    # relationship (with the parent of this object) is nullified.  
    # these are kept private so that we can control access (i.e. make sure the db is 
    # updated appropriately anytime something is changed/added)
    has_many :children, class_name: "Places::Place" # places within this place
    belongs_to :parent, class_name: "Places::Place", dependent: :nullify  # places containing this place 
          
  end   # class Place
end # module Places
