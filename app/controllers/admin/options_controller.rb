class Admin::OptionsController < Admin::BaseController
  before_action :find_cuisine
  before_action :find_option, only: [:destroy, :update, :edit]

  # Your actions here
  # For example, to create a new option:
  def new
    @option = @cuisine.options.build
  end

  def create
    @option = @cuisine.options.build option_params
    if @option.save
      flash[:success] = t(".success")

    else
      flash.now[:danger] = t(".fail")
    end
    redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
  end

  def edit; end

  def update
    if @option.update(option_params)
      flash[:success] = t(".success")

    else
      flash.now[:danger] = t(".fail")
    end
    redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
  end

  def destroy
    if @option.destroy
      flash[:success] = t(".success")
    else
      flash[:danger] = t(".fail")
    end
    redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
  end

  private

  def option_params
    params.require(:option).permit(:name, :price)
  end

  def find_cuisine
    @cuisine = Cuisine.find_by(slug: params[:cuisine_slug])
    return if @cuisine

    flash[:danger] = t(".not_found")
    redirect_to admin_cuisines_path
  end

  def find_option
    @option = Option.find_by(id: params[:id])
    return if @option

    flash[:danger] = t(".not_found")
    redirect_to edit_admin_cuisine_path(slug: @cuisine.slug)
  end
end
