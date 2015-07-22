
module Places
  class Country < Places::Place
    include ::Mongoid::Document

    def is_valid_parent?(pa)
      pa.entity_type == 'planet'
    end

    protected
    def get_entity_type
        'country'
    end

  end   # class State
end # module Places
