Obj = Struct.new(:foo)

class FooForm < Ciesta::Form
  field :foo, type: Ciesta::Types::Coercible::Int, default: 0
end

RSpec.describe 'types' do
  let(:obj) { Obj.new }
  let(:form) { FooForm.new(obj) }

  before { form.assign(foo: foo) }

  context 'string' do
    let(:foo) { '42' }

    specify { expect(form.foo).to eq(42) }
  end

  context 'float' do
    let(:foo) { 42.00 }

    specify { expect(form.foo).to eq(42) }
  end
end
