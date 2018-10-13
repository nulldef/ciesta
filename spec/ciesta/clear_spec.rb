class ClearForm
  include Ciesta

  field :name
end

RSpec.describe "clear attributes" do
  specify do
    form = ClearForm.new
    form.assign(name: "John")
    form = ClearForm.new
    expect(form.name).to be_nil
  end

  describe "#clear!" do
    specify do
      form = ClearForm.new(name: "John")
      expect(form.name).to eq("John")
      form.clear!
      expect(form.name).to be_nil
    end
  end
end
