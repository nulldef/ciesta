# frozen_string_literal: true

module Ciesta
  # Error for violating constraints
  ViolatesConstraints = Class.new(ArgumentError)

  # Error for invalid object
  FormNotValid = Class.new(StandardError)

  # Error for missing field definition
  FieldNotDefined = Class.new(NoMethodError)

  # Error for nil object
  ModelNotPresent = Class.new(StandardError)
end
