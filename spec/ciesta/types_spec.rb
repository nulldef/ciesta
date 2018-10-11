# frozen_string_literal: true

Obj = Struct.new(:foo)

class FooForm
  include Ciesta

  field :foo, type: Ciesta::Types::Coercible::Integer, default: 0
end

RSpec.describe "types" do
  let(:obj) { Obj.new }
  let(:form) { FooForm.new(obj) }

  before { form.assign(foo: foo) }

  context "string" do
    let(:foo) { "42" }

    specify { expect(form.foo).to eq(42) }
  end

  context "float" do
    let(:foo) { 42.00 }

    specify { expect(form.foo).to eq(42) }
  end
end
