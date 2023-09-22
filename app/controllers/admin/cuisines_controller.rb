class Admin::CuisinesController < Admin::BaseController
  before_action :find_cuisine, only: %i(edit update destroy)
  before_action :load_categories, only: %i(new edit create)

  def index
    @q = Cuisine.ransack(params[:q])
    @pagy, @cuisines = pagy(@q
    .result(distinct: true)
    .includes(:options, :category).order(created_at: :desc),
                            items: Settings.config.cuisines_per_page)
  end

  def new
    @cuisine = Cuisine.new
  end

  def create
    @cuisine = Cuisine.new(cuisine_params)
    @cuisine.slug = @cuisine.name.parameterize
    save_image @cuisine

    if @cuisine.save
      flash[:success] = t(".success")
      redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
    else
      flash.now[:danger] = t(".fail")
      render :new
    end
  end

  def edit; end

  def update
    save_image @cuisine
    if @cuisine.update(cuisine_params)
      flash[:success] = t(".success")
      redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
    else
      flash.now[:danger] = t(".fail")
      render :edit
    end
  end

  def destroy
    if @cuisine.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".fail")
    end
    redirect_to admin_cuisines_path
  end

  private

  def cuisine_params
    params.require(:cuisine).permit(:name, :description, :price, :discount,
                                    :available, :category_id, :main_image)
  end

  def find_cuisine
    @cuisine = Cuisine.find_by(slug: params[:slug])
    return if @cuisine

    flash[:danger] = t(".not_found")
    redirect_to admin_cuisines_path
  end

  def save_image cuisine
    return if params[:cuisine][:image].blank?

    cuisine.image.attach(params[:cuisine][:image])
  end

  def load_categories
    @categories = Category.pluck(:name, :id)
  end
end
