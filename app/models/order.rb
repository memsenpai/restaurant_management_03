class Order < ApplicationRecord
  include Encode
  enum status: %i(uncheck declined approved serving done).freeze
  ORDER_ATTRIBUTES = [
    :discount, :day, :time_in, :status,
    customer_attributes: %i(id name).freeze,
    table_attributes: %i(id capacity).freeze
  ].freeze

  belongs_to :customer
  belongs_to :table, inverse_of: :orders
  delegate :capacity, to: :table

  has_many :order_dishes, dependent: :destroy
  has_many :order_combos, dependent: :destroy
  has_one :bill

  delegate :code, to: :customer, prefix: :customer

  validate :validate_table, on: :create

  after_save :generate_code

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :table

  after_update_commit{OrderBroadcastJob.perform_now messages_data("update")}
  after_create_commit{OrderBroadcastJob.perform_now messages_data("create")}
  after_update_commit :change_status_item

  timein_between = lambda do |datefrom, dateto|
    where(day: datefrom..dateto)
  end

  order_by_timein = lambda do |order_by|
    select("time_in, count(time_in) as times")
      .group(:time_in)
      .order("time_in, times #{order_by}")
  end

  scope :timein_between, timein_between

  scope :order_by_timein, order_by_timein

  private

  def validate_table
    datetime = DateTime.parse(day.to_s << " " << time_in.to_s).in_time_zone.utc
    errors.add :table unless Table.find_by(id: table_id).is_available? datetime
  end

  def messages_data action
    {
      action: action, name: customer.name, id: id, discount: discount,
      table_id: table_id, capacity: capacity,
      day: day.in_time_zone.strftime(I18n.t("date_default")),
      time_in: time_in, status: status
    }
  end

  def check_change arg
    name = send(arg)
    # rubocop:disable SkipsModelValidations
    name.update_all cooking_time: Time.now.in_time_zone
    # rubocop:enable SkipsModelValidations
    name.map{|item| item.needing! unless item.cancel? || item.needing?}
  end

  def change_status_item
    customer.increase_warning if declined?
    chang_status_done

    return unless serving?
    check_change "order_dishes"
    check_change "order_combos"
  end

  def chang_status_done
    return unless done?
    BillService.new(self).create_bill_info
  end
end
