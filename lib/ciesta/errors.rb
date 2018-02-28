module Ciesta
  ViolatesConstraints = Class.new(ArgumentError)
  NotValid = Class.new(StandardError)
  FieldNotDefined = Class.new(NoMethodError)
end
