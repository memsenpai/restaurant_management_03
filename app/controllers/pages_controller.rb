class PagesController < ApplicationController
  def show
    current_ability
    if valid_page?
      @combos = Combo.popular_combos
      @dishes = Dish.popular_dishes
      render "pages/#{params[:page]}"
    else
      render "public/404.html", status: :not_found
    end
  end

  private

  def valid_page?
    File.exist? Pathname.new(Rails.root +
      "app/views/pages/#{params[:page]}.html.erb")
  end
end
