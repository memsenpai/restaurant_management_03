module Admin
  class XmlController < ApplicationController
    before_action :authenticate_staff!

    def show
      @bill = Bill.find_by id: params[:id]

      return redirect_to admin_bill_url unless bill
      respond_to_xls bill
    end

    private

    attr_reader :bill

    def respond_to_xls bill
      respond_to do |format|
        format.html
        format.xls do
          send_data bill.bill_details.to_xls(bill),
            filename: "bill_detail_#{Time.zone.today}.xls"
        end
      end
    end
  end
end
