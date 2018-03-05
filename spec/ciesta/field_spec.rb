# frozen_string_literal: true

RSpec.describe Ciesta::Field do
  let(:type) { Ciesta::Types::Coercible::Int.optional }
  let(:options) { Hash[type: type, default: default] }
  let(:field) { described_class.new(:foo, **options) }
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

    context "when default is proc" do
      let(:default) { -> { 10 } }

      specify { is_expected.to eq(10) }
    end
  end

  context "setting value" do
    subject(:setting) { field.value = value }

    context "when value was set to nit" do
      let(:value) { nil }

      specify { expect { setting }.to change(field, :value).to(nil) }
    end

    context "when value is specified" do
      let(:value) { "228" }

      specify { expect { setting }.to change(field, :value).to(228) }
    end
  end
end
