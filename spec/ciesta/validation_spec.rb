# frozen_string_literal: true

ValidationUser = Struct.new(:name, :age)

class ValidationForm < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

RSpec.describe "validation" do
  subject(:validation) { form.valid? }

  let(:form) { ValidationForm.new(user) }

  before { form.assign(attributes) }

  shared_examples :check_params do
    context "when params are right" do
      let(:attributes) { Hash[name: "Neo", age: 20] }

      specify { expect(validation).to be_truthy }
    end

    context "when params are invalid" do
      let(:attributes) { Hash[name: "Neo", age: 5] }

      specify { expect(validation).to be_falsey }
    end
  end

  context "when object is filled" do
    let(:user) { ValidationUser.new("John", 42) }

    it_behaves_like :check_params
  end

  context "when object is empty" do
    let(:user) { ValidationUser.new(nil, nil) }

    it_behaves_like :check_params
  end
end
