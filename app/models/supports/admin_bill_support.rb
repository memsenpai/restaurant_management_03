module Supports
  class AdminBillSupport
    attr_reader :bills, :params

    def initialize arg
      @dishes = arg[:bills]
      @params = arg[:params]
    end

    def bills_search
      search.result.page(params[:page]).per_page Settings.max_result
    end

    def search
      search = Bill.ransack params[:q]
      search.sorts = "id desc" if search.sorts.empty?
      search
    end
  end
end
