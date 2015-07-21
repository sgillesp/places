
module Places
  class County < Places::Place
    include ::Mongoid::Document

    def entity_type
        return 'county'
    end

    # states can only be added to countries
    def is_valid_parent?(pa)
        invalid_parent_error if pa.entity_type != "state"
    end

  end   # class State
end # module Places
