SyncingUser = Struct.new(:name, :age)

class SyncingForm < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

RSpec.describe Ciesta::Form do
  let(:form) { SyncingForm.new(user) }
  let(:user) { SyncingUser.new(nil, nil) }

  subject(:validation) { form.valid?(attributes) }

  context 'with bang' do
    context 'when params are valid' do
      let(:attributes) { Hash[name: 'Neo', age: 20] }

      before { form.valid?(attributes) }

      context 'without block' do
        specify { expect { form.sync! }.not_to raise_error }
      end

      context 'with block' do
        specify { expect { |b| form.sync!(&b) }.to yield_with_args(user) }
      end
    end

    context 'when params are invalid' do
      let(:attributes) { Hash[name: 'Neo', age: 5] }

      before { form.valid?(attributes) }

      specify { expect { form.sync! }.to raise_error(Ciesta::NotValid) }
    end
  end

  context 'without bang' do
    before { form.valid?(attributes) }

    context 'when params are valid' do
      let(:attributes) { Hash[name: 'Neo', age: 20] }

      context 'without block' do
        specify { expect(form.sync).to be_truthy }
      end

      context 'with block' do
        specify { expect { |b| form.sync(&b) }.not_to yield_with_args(user) }
      end
    end

    context 'when params are invalid' do
      let(:attributes) { Hash[name: 'Neo', age: 5] }

      specify { expect(form.sync).to be_nil }
    end
  end
end
