class UsersController < ApplicationController
  before_action :set_user, only: %i(edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :logged_in_user, only: %i(edit update)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t(".success")
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      attach_image
      flash[:success] = t(".success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user)
          .permit(:first_name, :last_name, :email, :password,
                  :password_confirmation, :phone, :address, :avatar)
  end

  def set_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".user_not_found")
    redirect_to root_path
  end

  def correct_user
    redirect_to root_path, status: :see_other unless current_user? @user
  end

  def attach_image
    return if params.dig(:user, :avatar).blank?

    @user.avatar.attach params.dig(:user, :avatar)
  end
end
