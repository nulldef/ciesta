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

RSpec.describe Ciesta do
  it "has a version number" do
    expect(Ciesta::VERSION).not_to be nil
  end

  describe "creation" do
    context "when object has been passed" do
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
    subject(:form) { SuperForm.form_from(hash) }
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
end
