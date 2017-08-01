class Promo < ApplicationRecord
  PERMIT_ATTR =
    %i(dish_id discount start_day end_day start_time end_time).freeze

  belongs_to :dish

  delegate :image, :name, :description, to: :dish, prefix: :dish

  validates :dish, presence: true
  validates :start_day, presence: true
  validates :end_day, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  find_date_discount = lambda do |date|
    where "date(start_day) <= :date AND date(end_day) >= :date",
      date: date.strftime(I18n.t("day_default"))
  end

  find_time_discount = lambda do |time|
    where "time(start_time) <= :time AND time(end_time) >= :time",
      time: time.strftime(I18n.t("time_default"))
  end

  find_discount = lambda do |id, date, time|
    where("dish_id = :id_dish", id_dish: id)
      .find_time_discount(time).find_date_discount date
  end

  scope :find_date_discount, find_date_discount
  scope :find_time_discount, find_time_discount
  scope :find_discount, find_discount

  def is_available?
    check_between("day") && check_between("time")
  end

  private

  def check_between input
    format_input = I18n.t "#{input}_default"
    Time.zone.now.strftime(format_input)
      .between? send("start_#{input}").strftime(format_input),
      send("end_#{input}").strftime(format_input)
  end
end
