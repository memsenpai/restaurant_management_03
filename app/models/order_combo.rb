class OrderCombo < ApplicationRecord
  enum status: %i(no_need needing cooking cooked served cancel).freeze

  belongs_to :order
  belongs_to :combo

  has_many :history_items, dependent: :destroy, foreign_key: "item_id"

  validates :quantity, presence: true,
    numericality: {only_integer: true, greater_than: 0}
  validate :combo_present
  validate :order_present

  before_save :finalize

  after_update_commit{MessageBroadcastJob.perform_now describe}
  after_create_commit{save_history "create_new"}
  after_update_commit{save_history "add"}
  after_destroy_commit{save_history "remove"}

  load_order_combos = lambda do |id|
    order_combos = []
    where("order_id=?", id).pluck(:combo_id, :quantity)
      .map do |combo_id, quantity|
        order_combo = {quantity: quantity.to_s, combo_id: combo_id.to_s}
        order_combos.push order_combo
      end
    order_combos
  end

  scope :load_order_combos, load_order_combos

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

    return unless table
    {combo: combo.name, table: table.code, status: status}
  end

  def save_history brand
    brand = "cancel" if cancel?
    HistoryItem.create item_id: id, brand: brand, describe: quantity,
      time: created_at, class_name: self.class.name
  end
end
