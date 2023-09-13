class Admin::CategoriesController < ApplicationController
  layout "admin"

  before_action :find_category, only: %i(destroy)
  before_action :update_related_cuisines, only: %i(destroy)

  def index
    @q = Category.ransack(params[:q])
    @pagy, @categories = pagy(@q.result(distinct: true).includes(:cuisines),
                              items: Settings.config.categories_per_page)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)
    @category.slug = @category.name.parameterize
    @category.save
    redirect_to admin_categories_path
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.categories.success"
    else
      flash[:danger] = t "admin.categories.fail"
    end
    redirect_to admin_categories_path
  end

  private

  def find_category
    @category = Category.find_by(slug: params[:slug])
    return if @category

    flash[:danger] = t "admin.categories.not_found"
    redirect_to admin_categories_path
  end

  def update_related_cuisines
    cuisines_to_update = @category.cuisines
    default_category = Category.find_by(slug: "default")
    default_category ||= Category.create(name: "Default", slug: "default")

    cuisines_to_update.update_all(category_id: default_category.id)
  end
end
