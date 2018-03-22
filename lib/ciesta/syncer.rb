# frozen_string_literal: true

# Class for syncing fields and object
#
# @attr_reader [Object] object Form objecy
# @attr_reader [Ciesta::FieldList] fields Field list
class Ciesta::Syncer
  # Constructor
  #
  # @api private
  # @param [Object] object Form object
  # @param [Ciesta::FieldList] fields Field list
  def initialize(object, fields)
    @object = object
    @fields = fields
  end

  # Sync attributes with object
  #
  # @param [Block] block Block which will be yielded after syncing
  #
  # @return [Booelan]
  def sync
    return if object.nil?

    fields.each do |field|
      begin
        save_to_object(field)
      rescue StandardError
        nil
      end
    end

    yield(object) if block_given?

    true
  end

  # Sync attributes with object
  #
  # @param [Block] block Block which will be yielded after syncing
  #
  # @raise Ciesta::ModelNotPresent
  # @raise Ciesta::AttributeNotDefined
  # @return [Booelan]
  def sync!
    raise Ciesta::ModelNotPresent, "Cannot sync without model" if object.nil?

    fields.each { |field| save_to_object(field) }

    yield(object) if block_given?

    true
  end

  private

  attr_reader :object, :fields

  def save_to_object(field)
    object.send("#{field.name}=", field.value) unless field.virtual?
  rescue NoMethodError
    raise Ciesta::AttributeNotDefined, "Attribute #{field.name} is not defined on model"
  end
end
