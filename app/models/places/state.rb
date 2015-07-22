
module Places
  class State < ::Places::Place

    field   :capitol, type: String, default: "Olympia"

    # states can only be added to countries
    def is_valid_parent?(pa)
      pa.entity_type == "country"
    end

    protected
    def get_entity_type
        return 'state'
    end

  end   # class State
end # module Places
