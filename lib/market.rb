class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map { |vendor| vendor.name }
  end

  def vendors_that_sell(item)
    @vendors.find_all { |vendor| vendor.check_stock(item) > 0 }
  end

  def sorted_item_list
    unique_items.map { |item| item.name }.sort
  end

  def total_inventory
    inventory_hash = Hash.new
    unique_items.each do |item|
      inventory_hash[item] = {
        quantity: get_total_item_count(item),
        vendors: vendors_that_sell(item)
      }
    end
    inventory_hash
  end

  def unique_items
    @vendors.map do |vendor|
      vendor.inventory.map { |item, _| item }
    end.flatten.uniq
  end

  def get_total_item_count(item)
    vendors_that_sell(item).sum { |vendor| vendor.check_stock(item) }
  end
end