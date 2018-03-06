# frozen_string_literal: true

module Ciesta
  class Field
    DEFAULT_TYPE = Ciesta::Types::Any

    attr_reader :name, :type

    def initialize(name, options)
      @name = name.to_sym
      @type = options.delete(:type) || DEFAULT_TYPE
      @default = options.delete(:default)
    end

    def value=(val)
      @value = type[val]
      @was_set = true
    rescue Dry::Types::ConstraintError
      raise Ciesta::ViolatesConstraints, "#{val} is not a #{type.name}"
    end

    def value
      return @value if @was_set

      @value || default
    end

    def bind(obj)
      @binding = obj
    end

    private

    def default
      type[default_value]
    rescue Dry::Types::ConstraintError
      raise Ciesta::ViolatesConstraints, "#{def_value} is not a #{type.name}"
    end

    def default_value
      if @default.respond_to?(:call) && @binding
        @binding.instance_exec(&@default)
      else
        @default
      end
    end
  end
end
