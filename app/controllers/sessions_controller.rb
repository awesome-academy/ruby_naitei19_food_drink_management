class SessionsController < ApplicationController
  before_action :find_user, only: :create
  before_action :authenticate_user, only: :create

  def new; end

  def create
    reset_session
    remember_me @user
    log_in @user
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  def remember_me user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
  end

  private
  def find_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t(".user_not_found")
    render :new, status: :unprocessable_entity
  end

  def authenticate_user
    return if @user.authenticate params.dig(:session, :password)

    flash.now[:danger] = t(".invalid_combination")
    render :new, status: :unprocessable_entity
  end
end
