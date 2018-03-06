# frozen_string_literal: true

# Simple module for delegate methods
module Ciesta::Delegator
  # Delegates methods to object
  #
  # @param [Array<String, Symbol>] methods Methods to delegate
  # @param [Symbol] to Method's name delegate to
  def delegate(*methods, to:)
    methods.each do |name|
      method_def = [
        "def #{name}(*args, &block)",
        "  if !#{to}.nil?",
        "    #{to}.#{name}(*args, &block)",
        "  end",
        "end",
      ].join(";")

      module_eval(method_def)
    end
  end
end
