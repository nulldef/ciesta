# frozen_string_literal: true

# Validatior class for form
#
# @api private
# @attr_reader [Dry::Validation::Schema] schema Schema for validation
# @attr_reader [Array] errors Array with errors
class Ciesta::Validator
  # Constructor
  def initialize
    @errors = []
  end

  # Set schema for validation
  #
  # @param [Block] block Block wich returns the schema
  def use(&block)
    @schema = Dry::Validation.Form(&block)
  end

  # Checks if schema is valid
  #
  # @param [Hash<Symbol, any>] attributes Attributes to check
  #
  # @return [Boolean]
  def valid?(attributes)
    return true if schema.nil?

    @errors = schema.call(attributes).errors
    errors.empty?
  end

  private

  attr_reader :schema, :errors
end
