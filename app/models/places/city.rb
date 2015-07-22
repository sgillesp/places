
module Places
  class City < Places::Place
    include ::Mongoid::Document

    # states can only be added to countries
    def is_valid_parent?(pa)
      [ 'country', 'state', 'county' ].include?(pa.entity_type)
    end

    protected
    def get_entity_type
        'city'
    end

  end   # class State
end # module Places
