
module Places
  class City < Places::Place
    include ::Mongoid::Document

    def entity_type
        return 'city'
    end

    # states can only be added to countries
    def is_valid_parent?(pa)
        invalid_parent_error if ![ 'country', 'state', 'county' ].include?(pa.entity_type)
    end

  end   # class State
end # module Places
