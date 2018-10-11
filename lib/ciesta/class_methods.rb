module Ciesta
  module ClassMethods
    extend self

    def form_from(**hash)
      form = new
      hash.each do |(k, v)|
        form.public_send("#{k}=", v) if form.respond_to?("#{k}=")
      end
      form
    end

    # Declare new form field
    #
    # @param [Symbol] name Field name
    # @param [Hash] options Options
    # @option (see Ciesta::Field)
    def field(name, **options)
      name = name.to_sym
      fields << Ciesta::Field.new(name, options)
      proxy.instance_eval do
        define_method(name) { self.class.fields[name] }
        define_method("#{name}=") { |value| self.class.fields[name] = value }
      end
    end

    # Declare rules for valudation
    #
    # @param [Block] block Block with validation rules
    # @see http://dry-rb.org/gems/dry-validation
    def validate(&block)
      validator.use(&block)
    end

    # Returns field list
    #
    # @api private
    # @return [Ciesta::FieldList]
    def fields
      @fields ||= Ciesta::FieldList.new
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
