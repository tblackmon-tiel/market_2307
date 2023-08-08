require './lib/item'
require './lib/vendor'

RSpec.describe Vendor do
  before(:each) do
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  describe "#initialize" do
    it "exists" do
      expect(@vendor).to be_a Vendor
    end

    it "has readable attributes" do
      expect(@vendor.name).to eq("Rocky Mountain Fresh")
      expect(@vendor.inventory).to eq({})
    end
  end

  describe "#check_stock" do
    it "returns the number of an item in stock" do
      expect(@vendor.check_stock(@item1)).to eq(0)
    end
  end

  describe "#stock" do
    it "adds an item with the given quantity to inventory" do
      expect(@vendor.check_stock(@item1)).to eq(0)
      @vendor.stock(@item1, 30)

      expect(@vendor.check_stock(@item1)).to eq(30)

      @vendor.stock(@item1, 25)
      @vendor.stock(@item2, 12)

      expect(@vendor.check_stock(@item1)).to eq(55)
      expect(@vendor.inventory).to eq({@item1 => 55, @item2 => 12})
    end
  end
end