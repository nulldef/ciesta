# frozen_string_literal: true

# Class for storing form field
#
# @attr_reader [Symbol] name Field name
# @attr_reader [Ciesta::Types::Declaration] type Field type
class Ciesta::Field
  # Default type when another one is not passed
  DEFAULT_TYPE = Ciesta::Types::Any

  attr_reader :name, :type

  # Constructor
  #
  # @param [Symbol] name Name of the field
  # @param [Hash] options Field's options
  # @option [Ciesta::Types::Definition] :type Type of value stored in this field
  # @option [Proc, Lambda, any] :default Default value for this field
  def initialize(name, **options)
    @name = name.to_sym
    @type = options.delete(:type) || DEFAULT_TYPE
    @default = options.delete(:default)
  end

  # Sets a new value for field
  #
  # @param [any] val Value
  #
  # @raise Ciesta::ViolatesConstraints
  def value=(val)
    @value = type[val]
    @was_set = true
  rescue Dry::Types::ConstraintError
    raise Ciesta::ViolatesConstraints, "#{val} is not a valid #{name} (#{type.name})"
  end

  # Returns current value
  #
  # @return [any]
  def value
    return @value if @was_set

    @value || default
  end

  # Binds current field to object
  #
  # @api private
  # @param [Object] obj Object to mapping to
  def bind(obj)
    @binding = obj
  end

  # Clear field
  def clear!
    @value = nil
  end

  private

  # Returns typed default value for field
  #
  # @api private
  # @raise Ciesta::ViolatesConstraints
  # @return [any]
  def default
    type[raw_default]
  rescue Dry::Types::ConstraintError
    raise Ciesta::ViolatesConstraints, "#{raw_default} is not a #{type.name}"
  end

  # Returns raw default value
  #
  # @api private
  # @return [any]
  def raw_default
    if @default.respond_to?(:call) && @binding
      @binding.instance_exec(&@default)
    else
      @default
    end
  end
end
