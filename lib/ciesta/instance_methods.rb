module Ciesta
  module InstanceMethods
    extend Ciesta::Delegator

    # @!method assign
    # @!method assign!
    # @!method attributes
    # @see Ciesta::FieldList
    delegate :assign, :assign!, :attributes, :clear!, to: :fields

    # @!method errors
    # @see Ciesta::Validator
    delegate :errors, to: :validator

    # @!method sync
    # @!method sync!
    # @see Ciesta::Syncer
    delegate :sync, to: :syncer

    attr_accessor :object

    # Constructor
    #
    # @param [Object] object Object wich will be updated though this form
    def initialize(object = nil)
      @object = object
      clear!

      return if object.nil?

      values = fields.keys.each_with_object({}) do |key, mem|
        mem[key] = object.public_send(key) if object.respond_to?(key)
      end

      assign(values)
    end

    # Checks if form is valid
    #
    # @param [Hash] params Attrubutes to assign before validation
    #
    # @return [Boolean]
    def valid?(params = nil)
      assign(params) if params
      validator.valid?(attributes)
    end

    # Sync form attributes to object
    #
    # @see Ciesta::Syncer
    #
    # @param [Block] block Block wich will be yielded after synfing
    #
    # @raise Ciesta::ModelNotPresent
    # @raise Ciesta::FormNotValid
    # @return [Boolean]
    def sync!(&block)
      raise Ciesta::FormNotValid, "Form is not valid" unless valid?
      syncer.sync!(&block)
    end

    private

    # Sync class for form
    #
    # @api private
    # @return [Ciesta::Syncer]
    def syncer
      @syncer ||= Ciesta::Syncer.new(object, fields)
    end

    # Returns form validator
    #
    # @api private
    # @see Ciesta::Form.validator
    def validator
      self.class.validator
    end

    # Returns field list
    #
    # @api private
    # @see Ciesta::Form.fields
    def fields
      self.class.fields
    end
  end
end
