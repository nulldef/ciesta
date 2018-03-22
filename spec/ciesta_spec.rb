# frozen_string_literal: true

class CarForm < Ciesta::Form
  field :speed
  field :wheels, default: 4
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
end
