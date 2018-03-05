# frozen_string_literal: true

module Ciesta
  ViolatesConstraints = Class.new(ArgumentError)
  NotValid = Class.new(StandardError)
  FieldNotDefined = Class.new(NoMethodError)
end
