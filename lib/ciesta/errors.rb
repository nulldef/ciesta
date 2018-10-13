# frozen_string_literal: true

module Ciesta
  # Error for violating constraints
  ViolatesConstraints = Class.new(ArgumentError)

  # Error for missing field definition
  FieldNotDefined = Class.new(NoMethodError)
end
