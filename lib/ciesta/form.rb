module Ciesta
  class Form
    extend Delegator

    delegate :assign, :assign!, :attributes, to: :fields
    delegate :sync!, :sync, to: :syncer
    delegate :errors, to: :validator

    def self.field(name, options = {})
      name = name.to_sym
      fields << Ciesta::Field.new(name, options)

      define_method(name) { fields[name] }
      define_method("#{name}=") { |value| fields[name] = value }
    end

    def self.validate(&block)
      validator.use(&block)
    end

    attr_accessor :object

    def initialize(object)
      self.object = object

      obj_values = fields.keys.each_with_object({}) do |key, mem|
        mem[key] = object.public_send(key)
      end

      assign(obj_values)
    end

    def valid?(params = nil)
      assign(params) if params
      validator.valid?(attributes)
    end

    def sync!(&block)
      raise Ciesta::NotValid, 'Form is not valid' unless valid?
      syncer.sync!(&block)
    end

    private

    def self.fields
      @fields ||= FieldList.new
    end

    def self.validator
      @validator ||= Ciesta::Validator.new
    end

    def syncer
      @syncer ||= Syncer.new(object, fields)
    end

    def validator
      self.class.validator
    end

    def fields
      self.class.fields
    end
  end
end
