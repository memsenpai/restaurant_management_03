module Api
  class BaseController < ActionController::API
    include Authenticable
    acts_as_token_authentication_handler_for Staff, fallback: :none

    before_action :authenticate_user_from_token

    alias authenticate_user_from_token authenticate_with_token!
  end
end
