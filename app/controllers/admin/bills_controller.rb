module Admin
  class BillsController < ApplicationController
    before_action :authenticate_staff!
    before_action :find_bill, only: :show

    def index
      @bills = Supports::AdminBillSupport.new bills: Bill.all, params: params
    end

    def create
      @bill = Bill.find_by order_id: bill_params[:order_id]

      return render_bill if bill
      @bill = Bill.new bill_params
      return render json: nil unless bill.save
      render_bill
    end

    def show
      respond_to do |format|
        format.html
        format.pdf do
          pdf = Pdf.new bill
          send_data pdf.render,
            filename: "bill-#{Time.zone.today}.pdf",
            type: "application/pdf"
        end
      end
    end

    private

    attr_reader :bill

    def bill_params
      params.require(:bill).permit Bill::ATTRIBUTES
    end

    def find_bill
      @bill = Bill.find_by id: params[:id]

      redirect_to admin_bills_url unless bill
    end

    def render_bill
      bill.update_attributes discount: params[:bill][:discount]
      redirect_to admin_bill_path(bill)
    end
  end
end
