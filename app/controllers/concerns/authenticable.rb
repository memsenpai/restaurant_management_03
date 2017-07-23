module Authenticable
  def current_user
    header = request.headers["AUTHENTICATE-TOKEN"]

    return unless header
    @current_user ||= Staff.find_by authentication_token: header
  end

  def authenticate_with_token!
    return if current_user
    render json: {
      messages: I18n.t("devise.failure.unauthenticated")
    }, status: :unauthorized
  end
end
