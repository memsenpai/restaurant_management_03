module Api
  class SessionsController < Devise::SessionsController
    attr_reader :staff

    skip_before_action :verify_signed_out_user, only: :destroy
    protect_from_forgery with: :null_session

    before_action :ensure_params_exist, :load_staff, only: :create
    before_action :valid_token, only: :destroy

    def create
      if staff.valid_password? sign_in_params[:password]
        login staff
      else
        invalid_login_attempt
      end
    end

    def destroy
      sign_out staff
      staff.generate_new_token
      render json: {
        messages: I18n.t("devise.sessions.signed_out")
      }, status: :ok
    end

    private

    def sign_in_params
      params.require(:sign_in).permit :email, :password
    end

    def ensure_params_exist
      return if params[:sign_in].present?
      render json: {
        messages: I18n.t("api.missing_params")
      }, status: :unauthorized
    end

    def invalid_login_attempt
      render json: {
        messages: I18n.t("devise.failure.invalid", authentication_keys: "email")
      }, status: :unauthorized
    end

    def load_staff
      @staff =
        Staff.find_for_database_authentication email: sign_in_params[:email]

      return if staff
      render json: {
        messages: I18n.t("devise.failure.invalid", authentication_keys: "email")
      }, status: :not_found
    end

    def valid_token
      @staff =
        Staff.find_by authentication_token:
          request.headers["AUTHENTICATE-TOKEN"]

      return if staff
      render json: {
        messages: I18n.t("api.invalid_token")
      }, status: :not_found
    end

    def login staff
      sign_in "staff", staff
      render json: {
        messages: I18n.t("devise.sessions.signed_in"),
        staff: {
          email: staff.email,
          authen_token: staff.authentication_token
        }
      }, status: :ok
    end
  end
end
