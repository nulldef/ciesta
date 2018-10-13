# frozen_string_literal: true

# List of object fields
#
# @attr_reader [Hash<Symbol, Ciesta::Field>] list Field list
class Ciesta::FieldList
  def self.define(definitions)
    definitions.each_with_object(new) do |(name, options), list|
      list << Ciesta::Field.new(name, options)
    end
  end

  # Constructor
  def initialize
    @list = {}
  end

  # Adds new field to list
  #
  # @param [Ciesta::Field] field New field
  # @api private
  def <<(field)
    list[field.name] = field
  end

  # Getting field by name
  #
  # @api private
  # @param [Symbol] name Field name
  #
  # @return [Ciesta::Field]
  def [](name)
    list[name.to_sym].value
  end

  # Setting field value
  #
  # @api private
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
    begin
      assign!(attributes)
    rescue Ciesta::FieldNotDefined
    end
  end

  # Getting all field names
  #
  # @api private
  # @return [Array<Symbol>]
  def keys
    list.keys
  end

  # Getting all field values
  #
  # @api private
  # @return [Hash<Symbol, any>]
  def attributes
    list.values.map { |field| [field.name, field.value] }.to_h
  end

  # Clear all fields
  #
  # @api private
  def clear!
    list.each_value(&:clear!)
  end

  private

  attr_reader :list
end
