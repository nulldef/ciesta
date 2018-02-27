module Ciesta
  class Validator
    attr_accessor :schema, :errors

    def initialize(&block)
      self.schema = Dry::Validation.Form(&block)
    end

    def valid?(attributes)
      self.errors = schema.call(attributes).errors
      errors.empty?
    end
  end
end
