# frozen_string_literal: true

module Ciesta
  class FieldList
    attr_reader :list

    def initialize
      @list = {}
    end

    def <<(field)
      list[field.name] = field
    end

    def [](name)
      list[name.to_sym].value
    end

    def []=(name, value)
      list[name.to_sym].value = value
    end

    def assign!(attributes)
      attributes.each { |name, value| self[name] = value }
      true
    rescue NoMethodError => e
      raise Ciesta::FieldNotDefined, e.message
    end

    def assign(attributes)
      attributes = attributes.keep_if { |key| keys.include?(key) }
      assign!(attributes) rescue false
    end

    def keys
      list.keys
    end

    def attributes
      list.values.each_with_object({}) { |field, mem| mem[field.name] = field.value }
    end

    def each
      list.each { |name, field| yield(name, field.value) }
    end
  end
end
