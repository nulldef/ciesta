# frozen_string_literal: true

class AssignForm
  include Ciesta

  field :foo
end

RSpec.describe "assign" do
  let(:hash) { Hash[foo: 0] }
  let(:form) { AssignForm.new(hash) }

  it "assigns a value" do
    expect(form.foo).to eq(0)
    expect { form.foo = 111 }.to change(form, :foo).to(111)
  end

  context "with bang" do
    subject(:assigning) { form.assign!(params) }

    context "with invalid params" do
      let(:params) { Hash[bar: 42] }

      specify { expect { assigning }.to raise_error(Ciesta::FieldNotDefined) }
    end

    context "with valid params" do
      let(:params) { Hash[foo: 42] }

      specify { expect { assigning }.to change(form, :foo).to(42) }
    end

    context "with form without an initial values" do
      let(:form) { AssignForm.new }
      let(:params) { Hash[foo: 42] }

      specify { expect { assigning }.to change(form, :foo).to(42) }
    end
  end

  context "without bang" do
    subject(:assigning) { form.assign(params) }

    context "with invalid params" do
      let(:params) { Hash[bar: 42] }

      specify { expect { assigning }.not_to change(form, :foo) }
    end

    context "with valid params" do
      let(:params) { Hash[bar: 1, foo: 42] }

      specify { expect { assigning }.to change(form, :foo).to(42) }
    end

    context "with form without an initial values" do
      let(:form) { AssignForm.new }
      let(:params) { Hash[foo: 42] }

      specify { expect { assigning }.to change(form, :foo).to(42) }
    end
  end
end
