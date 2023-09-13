class OrderItemsController < ApplicationController
  def new
    order_item_tmp = session[:order][params[:index].to_i]
    option = find_option order_item_tmp
    option_prices = option.price.to_i
    @order_item = order_item_new order_item_tmp, option_prices
    render partial: "form"
  end

  def create
    index = params[:order_item][:index]
    order_item_tmp = session[:order][index.to_i]
    order_item_tmp["quantity"] = order_item_params[:quantity]
    order_item_tmp["selected_option_id"] = order_item_params[:option_id]
    session[:order][index.to_i] = order_item_tmp
    @order = session[:order]
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :option_id, :index)
  end

  def order_item_new order_item_tmp, option_prices
    OrderItem.new(
      quantity: order_item_tmp["quantity"],
      cuisine_id: order_item_tmp["cuisine"]["id"],
      price: order_item_tmp["cuisine"]["price"],
      option_id: order_item_tmp["selected_option_id"],
      option_price: option_prices
    )
  end

  def find_option order_item_tmp
    option_id = order_item_tmp["selected_option_id"]
    option = Option.find_by(id: option_id)
    return option if option

    flash[:danger] = t "option.no_have"
    redirect_to root_path
  end
end
