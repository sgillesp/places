
module Places
  class State < ::Places::Place

    def entity_type
        return 'state'
    end

    # states can only be added to countries
    def is_valid_parent(pa)
        return pa.entity_type == "country"
    end
  
  end   # class State
end # module Places
