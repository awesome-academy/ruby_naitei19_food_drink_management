# app/controllers/cuisines_controller.rb
class CuisinesController < ApplicationController
  def index
    @q = Cuisine.ransack(params[:q])
    @cuisines = if params[:q].present?
                  @q.result(distinct: true)
                else
                  Cuisine.paginate(page: params[:page],
                                   per_page: Settings
                                   .config
                                   .pagination
                                   .cuisines_per_page)
                end.order_by_created_at
  end

  def show
    @cuisine = Cuisine.find_by(slug: params[:slug])
    return if @cuisine

    flash[:danger] = I18n.t "cuisine.not_have"
    redirect_to root_path
  end
end
