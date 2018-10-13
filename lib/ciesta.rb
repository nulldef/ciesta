# frozen_string_literal: true

require "forwardable"
require "dry-types"
require "dry-validation"
require "ciesta/version"
require "ciesta/field_list"
require "ciesta/types"
require "ciesta/validator"
require "ciesta/errors"
require "ciesta/field"
require "ciesta/class_methods"
require "ciesta/instance_methods"

module Ciesta
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end
end
