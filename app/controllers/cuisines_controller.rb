# app/controllers/cuisines_controller.rb
class CuisinesController < ApplicationController
  def index
    @q = Cuisine.ransack(params[:q])
    if params[:q].present?
      @pagy, @cuisines = pagy(@q.result(distinct: true),
                              items: Settings.config.pagination
                              .cuisines_per_page)
    else
      @pagy, @cuisines = pagy(Cuisine.order_by_created_at,
                              items: Settings.config.pagination
                              .cuisines_per_page)
    end
  end

  def show
    @cuisine = Cuisine.find_by(slug: params[:slug])
    return if @cuisine

    flash[:danger] = I18n.t "cuisine.not_have"
    redirect_to root_path
  end
end
