# frozen_string_literal: true

# List of object fields
#
# @api private
# @attr_reader [Hash<Symbol, Ciesta::Field>] list Field list
class Ciesta::FieldList
  # Constructor
  def initialize
    @list = {}
  end

  # Adds new field to list
  #
  # @param [Ciesta::Field] field New field
  def <<(field)
    list[field.name] = field
  end

  # Getting field by name
  #
  # @param [Symbol] name Field name
  #
  # @return [Ciesta::Field]
  def [](name)
    list[name.to_sym].value
  end

  # Setting field value
  #
  # @param [Symbol] name Field name
  # @param [any] value Field value
  def []=(name, value)
    list[name.to_sym].value = value
  end

  # Mass assign values to fields
  #
  # @param [Hash<Symbol, any>] attributes Attributes
  #
  # @raise Ciesta::FieldNotDefined
  # @return [Boolean]
  def assign!(attributes)
    attributes.each { |name, value| self[name] = value }
    true
  rescue NoMethodError => e
    raise Ciesta::FieldNotDefined, "Field #{e.name} is not specified"
  end

  # Mass assign values to fields
  #
  # @param [Hash<Symbol, any>] attributes Attributes
  #
  # @return [Boolean]
  def assign(attributes)
    attributes = attributes.keep_if { |key| keys.include?(key) }
    assign!(attributes) rescue false
  end

  # Getting all field names
  #
  # @return [Array<Symbol>]
  def keys
    list.keys
  end

  # Getting all field values
  #
  # @return [Hash<Symbol, any>]
  def attributes
    list.values.each_with_object({}) { |field, mem| mem[field.name] = field.value }
  end

  # Iterate over all fields
  #
  # @param [Block] block Block to iterate
  def each
    list.each { |name, field| yield(name, field.value) }
  end

  private

  attr_reader :list
end
