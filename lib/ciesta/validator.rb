# frozen_string_literal: true

# Validatior class for form
#
# @attr_reader [Dry::Validation::Schema] schema Schema for validation
# @attr_reader [Hash] errors Array with errors
class Ciesta::Validator
  attr_reader :errors

  # Constructor
  def initialize
    @errors = []
  end

  # Set schema for validation
  #
  # @api private
  # @param [Block] block Block wich returns the schema
  def use(&block)
    @schema = Dry::Validation.Form(&block)
  end

  # Checks if schema is valid
  #
  # @param [Hash<Symbol, any>] attributes Attributes to check
  #
  # @api private
  # @return [Boolean]
  def valid?(attributes)
    return true if schema.nil?

    @errors = schema.call(attributes).errors
    errors.empty?
  end

  private

  attr_reader :schema
end
