require 'places/location'

class Person
  include Mongoid::Document
  include Places::Location

  field :name, type: String
  field :address, type: String
end
