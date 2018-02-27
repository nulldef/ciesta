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

  let(:user) { User.new("John", 42) }
  let(:form) { Form.new(user) }
  let(:attributes) { Hash[name: "Neo", age: 20] }

  context "when validation is right" do
    specify { is_expected.to be_truthy }
  end
end
