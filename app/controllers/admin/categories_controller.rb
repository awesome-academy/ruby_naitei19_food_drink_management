class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, only: %i(edit update destroy)
  before_action :update_related_cuisines, only: %i(destroy)

  def index
    @q = Category.ransack(params[:q])
    @pagy, @categories = pagy(@q.result(distinct: true)
    .order_by_created_at.includes(:cuisines),
                              items: Settings.config.categories_per_page)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)
    @category.slug = @category.name.parameterize
    if @category.save
      flash[:success] = t "admin.categories.create.success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "admin.categories.create.fail"
      render :new
    end
  end

  def edit; end

  def update
    new_slug = categories_params[:name].parameterize
    handle_slug_change(new_slug)

    if @category.update(categories_params)
      flash[:success] = t "admin.categories.update.success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "admin.categories.update.fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "admin.categories.destroy.success"
    else
      flash[:danger] = t "admin.categories.destroy.fail"
    end
    redirect_to admin_categories_path
  end

  private

  def categories_params
    params.require(:category).permit(:name)
  end

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

  def handle_slug_change new_slug
    return unless new_slug != @category.slug

    if Category.by_slug(new_slug).any?
      flash[:danger] = t "admin.categories.update.duplicate_slug"
      render :edit
    else
      @category.slug = new_slug
    end
  end
end
