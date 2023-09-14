class OptionsController < ApplicationController
  before_action :find_cuisine, only: %i(create new)
  def create
    selected_option_id = option_params[:selected_option_id]
    order_item_data = {
      quantity: 1,
      cuisine: @cuisine,
      selected_option_id:
    }
    session[:order] ||= []
    existing_order_item = session[:order].find do |item|
      item["cuisine"]["id"] == order_item_data[:cuisine].id &&
        item["selected_option_id"] == order_item_data[:selected_option_id]
    end

    if existing_order_item
      existing_order_item["quantity"] += 1
    else
      session[:order].push(order_item_data)
    end
  end

  def new
    @option = @cuisine.options.new

    render partial: "options/form"
  end

  private

  def option_params
    params.require(:option).permit(:cuisine_id, :selected_option_id)
  end

  def find_cuisine
    cuisine_id = params[:cuisine_id] || option_params[:cuisine_id]
    @cuisine = Cuisine.find_by id: cuisine_id
    return if @cuisine

    flash[:danger] = I18n.t "cuisine.not_have"
    redirect_to root_path
  end
end
