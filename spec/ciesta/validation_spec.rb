User = Struct.new(:name, :age)

class Form < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

RSpec.describe "Validation" do
  subject(:validation) { form.valid?(attributes) }

  let(:form) { Form.new(user) }

  shared_examples :check_params do
    context "when params are right" do
      let(:attributes) { Hash[name: "Neo", age: 20] }

      specify { is_expected.to be_truthy }
    end

    context "when params are invalid" do
      let(:attributes) { Hash[name: "Neo", age: 5] }

      specify { is_expected.to be_falsey }
    end
  end

  context "when object is filled" do
    let(:user) { User.new("John", 42) }

    it_behaves_like :check_params
  end

  context "when object is empty" do
    let(:user) { User.new(nil, nil) }

    it_behaves_like :check_params
  end
end
