class ApplicationController < ActionController::Base
  include CuisineHelper
  include OrderHelper
  before_action :set_locale
  include SessionsHelper
  include Pagy::Backend

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t(".require_login")
    redirect_to login_path, status: :see_other
  end
end
