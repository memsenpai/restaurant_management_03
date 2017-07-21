class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  def current_ability
    @current_ability ||= Ability.new current_staff
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to staffs_path, flash: {danger: exception.message}
  end
end
