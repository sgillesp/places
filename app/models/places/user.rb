
module Places
  class User < Places::Place
    include ::Mongoid::Document

    field :address1, type: String
    field :address2, type: String
    field :city, type: String
    field :state, type: String
    field :zip, type: String

    def address
      [self.address1, self.address2, self.city, self.state, self.zip].join()
    end

    # states can only be added to cities, counties, states
    def is_valid_parent?(pa)
      [ 'city', 'state', 'county' ].include?(pa.entity_type)
    end

    protected
    def get_entity_type
        'user'
    end

  end   # class State
end # module Places
