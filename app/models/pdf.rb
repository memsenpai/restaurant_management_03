class Pdf < Prawn::Document
  def initialize bill
    super()
    @bill = bill
    pdf_layout
    bill_rows
    table_content
  end

  def pdf_layout
    text "##{bill.id}\n", size: 30, style: :bold, color: "ff0000"
    text I18n.t("admin.bills.customer_info"), size: 18, style: :bold
    customer_info
    text "#{I18n.t('admin.bills.bill_info')}\n", size: 18, style: :bold
    bill_info
  end

  private

  attr_reader :bill

  def customer_info
    text "\n\n\n\n\n\n\n\n"
    draw_text I18n.t("admin.bills.customer_code"), at: [20, 630], size: 13
    draw_text I18n.t("admin.bills.customer_name"), at: [20, 610], size: 13
    draw_text I18n.t("admin.bills.email"), at: [20, 590], size: 13
    draw_text I18n.t("admin.bills.mobile"), at: [20, 570], size: 13
  end

  def bill_info
    customer = bill.customer
    draw_text "##{customer.code}", at: [150, 630], size: 13, style: :italic
    draw_text customer.name.to_s, at: [150, 610], size: 13, style: :italic
    draw_text customer.email.to_s, at: [150, 590], size: 13, style: :italic
    draw_text customer.phone_num.to_s,
      at: [150, 570], size: 13, style: :italic
  end

  def table_content
    table bill_header + bill_rows + footer do
      row(0).font_style = :bold
    end
    text "\n\n"
    text I18n.t("admin.bills.total_price"),
      size: 25, style: :bold, color: "ff0000", align: :right
    text "$#{bill.total}\t\t",
      size: 25, style: :bold, color: "ff0000", align: :right
  end

  def bill_header
    header = %w()
    header << bill_header_content
  end

  def bill_header_content
    attribute =
      %W(#{I18n.t('admin.bills.item_type')} #{I18n.t('admin.bills.name_item')})
    attribute << I18n.t("admin.bills.quantity")
    attribute << I18n.t("admin.bills.price")
    attribute << I18n.t("admin.bills.discount")
    attribute << I18n.t("admin.bills.total_price")
  end

  def bill_rows
    attribute = %w()
    @bill.bill_details.map do |bill_detail|
      attribute << bill_row(bill_detail)
    end
    attribute
  end

  def bill_row bill_detail
    row = %W(#{bill_detail.type_name} #{bill_detail.item.name})
    row << bill_detail.quantity
    row << "$#{bill_detail.price}"
    row << "-#{bill_detail.discount}%"
    row << "$#{bill_detail.total_price}"
  end

  def footer
    footer = %w()
    footer << voucher
    footer << membership
    footer << total_price
  end

  def voucher
    attribute = %w()
    attribute << I18n.t("admin.bills.voucher")
    attribute << {content: "-#{bill.discount}%", colspan: 5}
  end

  def membership
    attribute = %w()
    attribute << I18n.t("admin.bills.membership")
    attribute << {content: "- #{bill.membership_point} Point", colspan: 5}
  end

  def total_price
    attribute = %w()
    attribute << I18n.t("admin.bills.total")
    attribute << {content: "$#{bill.total_price_bill_details}", colspan: 5}
  end
end
