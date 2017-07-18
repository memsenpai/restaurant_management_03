class BillDetail < ApplicationRecord
  belongs_to :bill

  validates :id_item, presence: true
  validates :price, presence: true, numericality: true
  validates :quantity, presence: true, numericality: {only_integer: true}
  validates :item_type, presence: true

  add_column_export = lambda do |csv, billdetails, bill_code|
    csv << %w(BillCode TimeCreated)
    csv << %W(#{bill_code} #{billdetails.first.bill.created_at})
    csv << %w(Id Type Name Quantity Price Discount Total)
    total_price = 0
    billdetails.each do |billdetail|
      total_price += billdetail.total_price
      attributes = %W(#{billdetail.id} #{billdetail.type_name})
      attributes << billdetail.item.name
      attributes << billdetail.quantity
      attributes << "$#{billdetail.price}"
      attributes << "#{billdetail.discount}%"
      attributes << "$#{billdetail.total_price}"
      csv << attributes
    end
  end

  scope :add_column_export, add_column_export

  def total_price
    (price * quantity * (100 - discount)) / 100
  end

  def item
    return Dish.find_by id: id_item if item_type == 1
    return Combo.find_by id: id_item if item_type == 2
  end

  def type_name
    return I18n.t "admin.dish" if item_type == 1
    return I18n.t "admin.combo" if item_type == 2
  end

  def self.to_xls billdetails, bill_code
    CSV.generate(headers: true) do |csv|
      add_column_export csv, billdetails, bill_code
    end
  end
end
