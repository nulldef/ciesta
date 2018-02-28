AssignObj = Struct.new(:foo)

class AssignForm < Ciesta::Form
  field :foo
end

RSpec.describe 'assign' do
  let(:obj) { AssignObj.new(0) }
  let(:form) { AssignForm.new(obj) }

  context 'with bang' do
    subject(:assigning) { form.assign!(params) }

    context 'with invalid params' do
      let(:params) { Hash[bar: 42] }

      specify { expect { assigning }.to raise_error(Ciesta::FieldNotDefined) }
    end

    context 'with valid params' do
      let(:params) { Hash[foo: 42] }

      specify { expect { assigning }.to change { form.foo }.by(42) }
    end
  end

  context 'without bang' do
    subject(:assigning) { form.assign(params) }

    context 'with invalid params' do
      let(:params) { Hash[bar: 42] }

      specify { expect { assigning }.not_to change { form.foo } }
    end

    context 'with valid params' do
      let(:params) { Hash[bar: 1, foo: 42] }

      specify { expect { assigning }.to change { form.foo }.by(42) }
    end
  end
end
