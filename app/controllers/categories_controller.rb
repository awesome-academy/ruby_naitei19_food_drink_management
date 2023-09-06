# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  before_action :load_categories, only: %i(index show)

  def index; end

  def show
    @category = Category.find_by(slug: params[:slug])

    if @category
      @cuisines = @category.cuisines.order_by_created_at
    else
      flash[:danger] = t "category.no_have"
      redirect_to root_path
    end
  end

  private

  def load_categories
    @categories = Category.paginate(page: params[:page],
                                    per_page: Settings
                                    .config
                                    .pagination
                                    .categories_per_page)
                          .sort_by_name
  end
end
