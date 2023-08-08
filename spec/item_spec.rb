require './lib/item'

RSpec.describe Item do
  before(:each) do
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
  end

  describe "#initialize" do
    it "exists" do
      expect(@item1).to be_an Item
    end

    it "has readable attributes" do
      expect(@item1.name).to eq("Peach")
      expect(@item1.price).to eq(0.75)
    end
  end
end