require 'date'

class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime("%d/%m/%Y")
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

  def overstocked_items
    total_inventory.find_all do |_, item_values|
      item_values[:quantity] > 50 && item_values[:vendors].size > 1
    end.map { |item| item.first } # find_all on a hash returns the key-value pair, just care about the key
  end

  def sell(item, quantity)
    return false if get_total_item_count(item) < quantity
    vendors_that_sell(item).each do |vendor|
      vendor_stock = vendor.check_stock(item)
      if vendor_stock >= quantity
        vendor.remove_stock(item, quantity)
        return true
      else
        quantity -= vendor_stock
        vendor.remove_stock(item, vendor_stock)
      end
    end
  end
end