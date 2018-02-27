RSpec.describe Ciesta::Field do
  let(:type) { Ciesta::Types::Coercible::Int.optional }
  let(:field) { described_class.new(:foo, type: type, default: default) }
  let(:default) { 42 }

  context "getting value" do
    subject(:getting) { field.value }

    context "when type is not passed" do
      let(:type) { nil }

      specify { is_expected.to eq(42) }
    end

    context "with coercible type" do
      let(:type) { Ciesta::Types::Coercible::String }

      specify { is_expected.to eq("42") }
    end

    context "with stric type" do
      let(:type) { Ciesta::Types::Strict::Float }

      specify { expect { getting }.to raise_error { Ciesta::ViolatesConstraints } }
    end

    context "when default is nil" do
      let(:default) { nil }

      specify { is_expected.to be_nil }
    end
  end

  context "setting value" do
    subject(:getting) { field.value }

    before { field.value = value }

    context "when value is nit" do
      let(:value) { nil }

      specify { is_expected.to be_nil }
    end

    context "when value is specified" do
      let(:value) { "228" }

      specify { is_expected.to eq(228) }
    end
  end
end
