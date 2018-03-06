# frozen_string_literal: true

class Ciesta::Syncer
  attr_reader :obj, :fields

  def initialize(obj, fields)
    @obj = obj
    @fields = fields
  end

  def sync!
    fields.each { |name, value| obj.send("#{name}=", value) }

    yield(obj) if block_given?

    true
  end

  def sync(&block)
    sync!(&block) rescue false
  end
end
