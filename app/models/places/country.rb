
module Places
  class Country < Places::Place
    include ::Mongoid::Document

    def entity_type
        return 'country'
    end
  
  end   # class State
end # module Places
