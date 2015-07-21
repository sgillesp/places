
module Places
  class Country < Places::Place
    include ::Mongoid::Document

    def entity_type
        return 'country'
    end

    def is_valid_parent?(pa)
      invalid_parent_error unless pa.entity_type = 'planet'
    end

  end   # class State
end # module Places
