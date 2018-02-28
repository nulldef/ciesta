module Ciesta
  class Validator
    attr_accessor :schema, :errors

    def initialize
      self.errors = []
    end

    def use(&block)
      self.schema = Dry::Validation.Form(&block)
    end

    def valid?(attributes)
      return true if schema.nil?

      self.errors = schema.call(attributes).errors
      errors.empty?
    end
  end
end
