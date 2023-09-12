class OptionsController < ApplicationController
  before_action :find_cuisine, only: %i(create new)
  def create
    selected_option_ids = option_params[:selected_option_ids]
    order_item_data = {
      cuisine: @cuisine,
      selected_option_ids:
    }
    session[:order] ||= []
    session[:order].push(order_item_data)
  end

  def new
    @option = @cuisine.options.new

    render partial: "options/form"
  end

  private

  def option_params
    params.require(:option).permit(:cuisine_id, selected_option_ids: [])
  end

  def find_cuisine
    cuisine_id = params[:cuisine_id] || option_params[:cuisine_id]
    @cuisine = Cuisine.find_by id: cuisine_id
    return if @cuisine

    flash[:danger] = I18n.t "cuisine.not_have"
    redirect_to root_path
  end
end
