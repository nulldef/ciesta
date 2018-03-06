# frozen_string_literal: true

module Ciesta
  # Error class for error about violating constraints
  ViolatesConstraints = Class.new(ArgumentError)

  # Error for invalid object
  ObjectNotValid = Class.new(StandardError)

  # Error for missing field definition
  FieldNotDefined = Class.new(NoMethodError)
end
