# frozen_string_literal: true

class Ciesta::Form
  extend Ciesta::Delegator

  delegate :assign, :assign!, :attributes, to: :fields
  delegate :sync!, :sync, to: :syncer
  delegate :errors, to: :validator

  class << self
    def field(name, options = {})
      name = name.to_sym
      fields << Ciesta::Field.new(name, options)

      define_method(name) { fields[name] }
      define_method("#{name}=") { |value| fields[name] = value }
    end

    def validate(&block)
      validator.use(&block)
    end

    def fields
      @fields ||= Ciesta::FieldList.new
    end

    def validator
      @validator ||= Ciesta::Validator.new
    end
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
    raise Ciesta::NotValid, "Form is not valid" unless valid?
    syncer.sync!(&block)
  end

  private

  def syncer
    @syncer ||= Ciesta::Syncer.new(object, fields)
  end

  def validator
    self.class.validator
  end

  def fields
    self.class.fields
  end
end
