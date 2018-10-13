# frozen_string_literal: true

class CarForm
  include Ciesta

  field :speed
  field :wheels, default: 4
end

class SuperForm
  include Ciesta

  field :number

  def number
    super.to_f
  end
end

class StrictForm
  include Ciesta

  field :smth, type: Ciesta::Types::Strict::Float
end

class CoercibleForm
  include Ciesta

  field :smth, type: Ciesta::Types::Coercible::Float
end

RSpec.describe Ciesta do
  it "has a version number" do
    expect(Ciesta::VERSION).not_to be nil
  end

  describe "creation" do
    context "when hash has been passed" do
      subject(:form) { CarForm.new }

      it "creates empty form object" do
        is_expected.to be_instance_of(CarForm)
        expect(form.speed).to be_nil
        expect(form.wheels).to eq(4)
      end
    end
  end

  describe "calling super" do
    subject(:form) { SuperForm.new }

    before { form.number = "0.12" }

    specify do
      expect(form.number).to be_a(Float)
      expect(form.number).to eq(0.12)
    end
  end

  describe "building form" do
    subject(:form) { SuperForm.new(hash) }
    let(:hash) { Hash[number: "33"] }

    it "builds form from hash" do
      is_expected.to be_a(SuperForm)
      expect(form.number).to eq(33.0)
    end

    context "key not matching methods" do
      let(:hash) { Hash[method: "1234", number: "1234"] }

      it "sets only existing keys" do
        is_expected.to be_a(SuperForm)
        expect(form.number).to eq(1234.0)
      end
    end
  end

  describe "types" do
    let(:hash) { Hash[smth: value] }
    let(:value) { 200.0 }

    context "strict types" do
      subject(:form) { StrictForm.new(hash) }

      specify { expect(form.smth).to eq(200.0) }

      context "invalid value" do
        let(:value) { 200 }

        specify { expect { form }.to raise_error { Ciesta::ViolatesConstraints } }
      end
    end

    context "coercible type" do
      subject(:form) { CoercibleForm.new(hash) }

      specify { expect(form.smth).to eq(200.0) }

      context "casts to float" do
        let(:value) { 200 }

        specify { expect(form.smth).to eq(200.0) }
      end
    end
  end
end
