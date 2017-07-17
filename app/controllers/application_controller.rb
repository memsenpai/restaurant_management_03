class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  def current_ability
    @current_ability ||= Ability.new current_admin
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, flash: {danger: exception.message}
  end

  private

  def logged_in_admin
    return if logged_in?
    flash[:danger] = t "admin.error_log"
    redirect_to login_url
  end
end
