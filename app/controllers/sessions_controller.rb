class SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user, only: :destroy

  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end
