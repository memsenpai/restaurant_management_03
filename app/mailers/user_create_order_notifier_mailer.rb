class UserCreateOrderNotifierMailer < ApplicationMailer
  attr_reader :order
  def send_email order
    @order = order
    mail to: order.guest.email,
      subject: t("admin.orders.order.success")
  end
end
