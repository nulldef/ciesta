module Ciesta
  module InstanceMethods
    extend Forwardable

    # @!method assign
    # @!method assign!
    # @!method attributes
    # @see Ciesta::FieldList
    def_delegators :fields, :assign, :assign!, :attributes, :clear!

    # @!method errors
    # @see Ciesta::Validator
    def_delegators :validator, :errors

    attr_reader :fields

    # Constructor
    #
    # @param [Hash] values Hash with values
    def initialize(values = {})
      @fields = Ciesta::FieldList.define(self.class.definitions)
      assign(values || {})
    end

    # Checks if form is valid
    #
    # @param [Hash] params Attrubutes to assign before validation
    #
    # @return [Boolean]
    def valid?(values = {})
      assign(values) unless values.empty?
      validator.valid?(attributes)
    end

    private

    # Returns form validator
    #
    # @api private
    # @see Ciesta::Form.validator
    def validator
      self.class.validator
    end
  end
end
