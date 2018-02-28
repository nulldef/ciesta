module Ciesta
  class Form
    def self.field(name, options = {})
      name = name.to_sym
      fields[name] ||= Ciesta::Field.new(name, options)

      define_method(name) { self.class.fields[name].value }
      define_method("#{name}=") { |value| self.class.fields[name].value = value }
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

    def assign!(attributes)
      attributes.each { |key, value| send("#{key}=", value) }
    rescue NoMethodError => e
      raise Ciesta::FieldNotDefined, e.message
    end

    def assign(params)
      keys = fields.keys
      params.keep_if { |key, _value| keys.include?(key) }
      begin
        assign!(params)
      rescue StandardError
        nil
      end
    end

    def errors
      validator.errors
    end

    def sync!
      raise Ciesta::NotValid, 'Form is not valid' unless errors.empty?

      fields.each { |name, field| object.send("#{name}=", field.value) }

      yield(object) if block_given?
      true
    end

    def sync
      sync!
    rescue StandardError
      nil
    end

    private

    def self.fields
      @fields ||= {}
    end

    def self.validator
      @validator ||= Ciesta::Validator.new
    end

    def validator
      self.class.validator
    end

    def fields
      self.class.fields
    end

    def attributes
      fields.values.each_with_object({}) do |field, mem|
        mem[field.name] = field.value
      end
    end
  end
end
