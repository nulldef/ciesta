module Ciesta
  class Form
    def self.field(name, options = {})
      name = name.to_sym
      fields[name] ||= Ciesta::Field.new(name, options)

      define_method(name) { fields[name].value }
      define_method("#{name}=") { |value| fields[name].value = value }
    end

    def self.validate(&block)
      self.validator = Ciesta::Validator.new(&block)
    end

    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def valid?(attributes)
      validator.valid?(attributes)
    end

    def errors
      validator.errors
    end

    private

    def self.fields
      @fields ||= {}
    end

    class << self
      attr_accessor :validator
    end

    def validator
      self.class.validator
    end
  end
end
