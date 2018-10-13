module Ciesta
  module ClassMethods
    extend self

    # Declare new form field
    #
    # @param [Symbol] name Field name
    # @param [Hash] options Options
    # @option (see Ciesta::Field)
    def field(name, **options)
      name = name.to_sym
      definitions[name] = options
      proxy.instance_eval do
        define_method(name) { fields[name] }
        define_method("#{name}=") { |value| fields[name] = value }
      end
    end

    # Declare rules for validation
    #
    # @param [Block] block Block with validation rules
    # @see http://dry-rb.org/gems/dry-validation
    def validate(&block)
      validator.use(&block)
    end

    # Returns fields definitions
    #
    # @api private
    # @return [Ciesta::FieldList]
    def definitions
      @definitions ||= {}
    end

    # Returns form validator
    #
    # @api private
    # @return [Ciesta::Validator]
    def validator
      @validator ||= Ciesta::Validator.new
    end

    def proxy
      @proxy ||= begin
        m = Module.new
        include m
        m
      end
    end
  end
end
