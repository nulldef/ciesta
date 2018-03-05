module Ciesta
  module Delegator
    def delegate(*methods, to:)
      methods.each do |name|
        method_def = [
          "def #{name}(*args, &block)",
          "  if !#{to}.nil?",
          "    #{to}.#{name}(*args, &block)",
          "  end",
          "end"
        ].join(";")

        module_eval(method_def)
      end
    end
  end
end
