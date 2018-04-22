class ClearForm < Ciesta::Form
  field :name
end

RSpec.describe "clear attributes" do
  specify do
    form = ClearForm.new
    form.assign(name: "John")
    form = ClearForm.new
    expect(form.name).to be_nil
  end
end
