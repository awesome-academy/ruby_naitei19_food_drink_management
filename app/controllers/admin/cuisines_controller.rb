class Admin::CuisinesController < ApplicationController
  layout "admin"

  def index
    @q = Cuisine.ransack(params[:q])
    @pagy, @cuisines = pagy(@q.result(distinct: true),
                            items: Settings.config.cuisines_per_page)
  end

  private

  def cuisine_params
    params.require(:cuisine).permit(:name, :description, :price, :discount,
                                    :available, :category_id)
  end
end
