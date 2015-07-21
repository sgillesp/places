# places/exceptions.rb

module Places
  class InvalidChild < RuntimeError; end
  class InvalidParent < RuntimeError; end
  class CircularRelation < RuntimeError; end
end # places
6
