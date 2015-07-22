
module Places
  class County < Places::Place
    include ::Mongoid::Document

    # states can only be added to countries
    def is_valid_parent?(pa)
      pa.entity_type == "state"
    end

    protected
    def get_entity_type
        return 'county'
    end

  end   # class State
end # module Places
