# frozen_string_literal: true

# Class for syncing fields and object
#
# @attr_reader [Object] object Form objecy
# @attr_reader [Ciesta::FieldList] fields Field list
class Ciesta::Syncer
  # Constructor
  #
  # @api private
  # @param [Object] object Form objecr
  # @param [Ciesta::FieldList] fields Field list
  def initialize(object, fields)
    @object = object
    @fields = fields
  end

  # Sync attributes with objec
  #
  # @param [Block] block Block which will be yielded after syncing
  #
  # @return [Booelan]
  def sync
    fields.each { |name, value| object.send("#{name}=", value) }

    yield(object) if block_given?

    true
  end

  private

  attr_reader :object, :fields
end
