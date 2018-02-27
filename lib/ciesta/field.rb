module Ciesta
  class Field
    DEFAULT_TYPE = Ciesta::Types::Any

    attr_accessor :name, :type

    def initialize(name, options)
      self.name = name.to_sym
      self.type = options.delete(:type) || DEFAULT_TYPE
      self.value = options.delete(:default)
    end

    def value
      current_value
    end

    def value=(val)
      self.current_value = type[val]
    rescue Dry::Types::ConstraintError
      raise ViolatesConstraints, "#{current_value} is not a #{type.name}"
    end

    private

    attr_accessor :current_value
  end
end
