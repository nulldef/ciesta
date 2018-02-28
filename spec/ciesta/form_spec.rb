User = Struct.new(:name, :age)

class Form < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

RSpec.describe Ciesta::Form do
  let(:form) { Form.new(user) }

  subject(:validation) { form.valid?(attributes) }

  context 'validation' do
    shared_examples :check_params do
      context 'when params are right' do
        let(:attributes) { Hash[name: 'Neo', age: 20] }

        specify { expect(validation).to be_truthy }
      end

      context 'when params are invalid' do
        let(:attributes) { Hash[name: 'Neo', age: 5] }

        specify { expect(validation).to be_falsey }
      end
    end

    context 'when object is filled' do
      let(:user) { User.new('John', 42) }

      it_behaves_like :check_params
    end

    context 'when object is empty' do
      let(:user) { User.new(nil, nil) }

      it_behaves_like :check_params
    end
  end

  context 'syncing' do
    let(:user) { User.new(nil, nil) }

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
      context 'when params are valid' do
        let(:attributes) { Hash[name: 'Neo', age: 20] }

        before { form.valid?(attributes) }

        context 'without block' do
          specify { expect(form.sync).to be_truthy }
        end

        context 'with block' do
          specify { expect { |b| form.sync(&b) }.not_to yield_with_args(user) }
        end
      end

      context 'when params are invalid' do
        let(:attributes) { Hash[name: 'Neo', age: 5] }

        before { form.valid?(attributes) }

        specify { expect(form.sync).to be_nil }
      end
    end
  end
end
