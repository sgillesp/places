# location.rb

require 'active_support/concern'

module Places
  module Location
    extend ActiveSupport::Concern

    included do
      has_one :place_avatar, class_name: 'Places::Place', as: :owner, validate: true

      after_initialize :do_setup

      class_eval "def base_class; ::#{self.name}; end"
    end

    private
      # subclasses should overload create_place_avatar to create the appropriate Place object and set it up
      def do_setup
        if (self.place_avatar == nil)
          self.place_avatar = self.respond_to?(:create_place_avatar) ? self.create_place_avatar : Places::Place.new(name: self.name)
          self.place_avatar.owner = self
        end
      end

  end # module Location
end # module Places
