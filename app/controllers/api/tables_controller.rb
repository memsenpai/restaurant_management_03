module Api
  class TablesController < Api::BaseController
    before_action :find_table, only: [:show]

    def index
      render json: Table.all
    end

    def show
      render json: table
    end

    private

    attr_reader :table

    def find_table
      @table = Table.find_by id: params[:id]
      return if table
      render json: Array.new, status: :not_found
    end
  end
end
