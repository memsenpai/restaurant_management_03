class NotifierMailer < ApplicationMailer
  attr_reader :order
  def create_order order
    @order = order
    mail to: order.customer.email,
      subject: t("admin.orders.order.success")
  end

  def reject_order order
    @order = order
    mail to: order.customer.email,
      subject: t("reject_order")
  end

  def adv_promos promo
    Customer.all.map do |customer|
      adv_promo customer, promo
    end
  end

  def adv_promo customer, promo
    @customer = customer
    @promo = promo
    format_day = t "day_default"
    mail to: customer.email,
      subject: t("adv_promo", from: promo.start_day.strftime(format_day),
        to: promo.end_day.strftime(format_day), dish: promo.dish.name)
  end
end
