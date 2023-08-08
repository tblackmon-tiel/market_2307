require 'date'
require './lib/item'
require './lib/vendor'
require './lib/market'

RSpec.describe Market do
  before(:each) do
    @item1 = Item.new({name: "Peach", price: "$0.75"})
    @item2 = Item.new({name: "Tomato", price: "$0.50"})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end

  describe "#initialize" do
    it "exists" do
      expect(@market).to be_a Market
    end

    it "has readable attributes" do
      expect(@market.name).to eq("South Pearl Street Farmers Market")
      expect(@market.vendors).to eq([])
    end
  end

  describe "#date" do
    it "has a date" do
      expect(@market.date).to eq(Date.today.strftime("%d/%m/%Y"))
    end

    it "can have a date in the past or future" do
      allow(Date).to receive(:today).and_return(Date.new(2023, 07, 01))
      market2 = Market.new("We Live in the Past")
      expect(market2.date).to eq("01/07/2023")

      allow(Date).to receive(:today).and_return(Date.new(2024, 01, 11))
      market3 = Market.new("The Future is Now")
      expect(market3.date).to eq("11/01/2024")
    end
  end

  context "vendors are added" do
    before(:each) do 
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    describe "#add_vendor" do
      it "adds a vendor to the market vendor list" do
        expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
      end
    end
  
    describe "#vendor_names" do
      it "returns an array of all vendor names in the vendor list" do
        expect(@market.vendor_names).to eq(["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
      end
    end
  
    describe "#vendors_that_sell" do
      it "returns an array of vendors that sell a given item" do
        expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
        expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
      end
    end
  
    describe "#sorted_item_list" do
      it "returns an array of all items from all vendors sorted alphabetically, non-repeating" do
        expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
      end
    end
  
    describe "#total_inventory" do
      it "reports the quantities of all items sold at the market" do
        expect(@market.total_inventory).to eq({
          @item1 => {
            quantity: 100,
            vendors: [@vendor1, @vendor3]
          },
          @item2 => {
            quantity: 7,
            vendors: [@vendor1]
          },
          @item3 => {
            quantity: 25,
            vendors: [@vendor2]
          },
          @item4 => {
            quantity: 50,
            vendors: [@vendor2]
          }
        })
      end
    end
  
    describe "#unique_items" do
      it "returns an array of unique items from all vendors" do
        expect(@market.unique_items).to eq([@item1, @item2, @item4, @item3])
      end
    end
  
    describe "#get_total_item_count" do
      it "sums up the total number of an item being sold between all vendors" do
        expect(@market.get_total_item_count(@item1)).to eq(100)
      end
    end
  
    describe "#overstocked_items" do
      it "returns an array of items sold by more than one vendor with total quantity greater than 50" do
        expect(@market.overstocked_items).to eq([@item1])
  
        @vendor3.stock(@item2, 44)
  
        expect(@market.overstocked_items).to eq([@item1, @item2])
      end
    end
  
    describe "#sell" do
      it "returns false if the amount of an item requested cannot be fulfilled" do
        expect(@market.sell(@item1, 400)).to be false
      end
  
      it "returns true if the amount of an item requested can be fulfilled" do
        expect(@market.sell(@item1, 10)).to be true
      end
  
      it "removes the quantity requested from vendors until the quantity is fulfilled" do
        expect(@vendor1.check_stock(@item1)).to be(35)
        expect(@vendor3.check_stock(@item1)).to be(65)
  
        @market.sell(@item1, 10)
        expect(@vendor1.check_stock(@item1)).to be(25)
  
        @market.sell(@item1, 40)
        expect(@vendor1.check_stock(@item1)).to be(0)
        expect(@vendor3.check_stock(@item1)).to be(50)
        expect(@market.vendors_that_sell(@item1)).to eq([@vendor3])
      end
    end
  end
end