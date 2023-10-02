class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :logged_in_user
  before_action :check_authorization

  private
  def check_authorization
    redirect_to root_path unless current_user.admin?
  end

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t("admin.require_login")
    redirect_to new_user_session_path, status: :see_other
  end
end
