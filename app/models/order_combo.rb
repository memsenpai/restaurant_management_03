class OrderCombo < ApplicationRecord
  enum status: %i(no_need needing cooking cooked served cancel)

  belongs_to :order
  belongs_to :combo

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :combo_present
  validate :order_present

  before_save :finalize

  after_update_commit{MessageBroadcastJob.perform_now describe}

  def original_price
    combo.subtotal
  end

  def total_price
    price * quantity
  end

  private

  def combo_present
    errors.add :combo, I18n.t("order.not_valid_or_not_active") unless combo
  end

  def order_present
    errors.add :order, I18n.t("order.not_valid_value") unless order
  end

  def finalize
    self[:price] = combo.price
    self[:total_price] = quantity * self[:price]
  end

  def describe
    table = order.table
    {dish: combo.name, table: table.code, status: status}
  end
end
