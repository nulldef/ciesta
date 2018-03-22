# frozen_string_literal: true

SyncingUser = Struct.new(:name, :age)

class ValidationForm < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

class SimpleForm < Ciesta::Form
  field :name
  field :age
end

RSpec.describe Ciesta::Form do
  let(:user) { SyncingUser.new(nil, nil) }
  let(:attributes) { Hash[name: "Neo", age: 20] }

  before { form.assign(attributes) }

  context "without validation" do
    let(:form) { SimpleForm.new(user) }

    specify { expect { form.sync! }.to change(user, :name).to("Neo") }
    specify { expect { form.sync! }.to change(user, :age).to(20) }
  end

  context "with validation" do
    let(:form) { ValidationForm.new(user) }

    context "when params are valid" do
      context "without block" do
        specify { expect { form.sync! }.not_to raise_error }
      end

      context "with block" do
        specify { expect { |b| form.sync!(&b) }.to yield_with_args(user) }
      end
    end

    context "when params are invalid" do
      let(:attributes) { Hash[name: "Neo", age: 5] }

      specify do
        expect { form.sync! }.to raise_error(Ciesta::FormNotValid)
        expect(form.errors).to eq(age: ["must be greater than 18"])
      end
    end

    context "when object not passed" do
      let(:attributes) { Hash[name: "Neo", age: 5] }
      let(:form) { ValidationForm.new }

      specify { expect { form.sync! }.to raise_error(Ciesta::ModelNotPresent) }
      specify { expect(form.sync).to be_falsey }
    end
  end
end
