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
    order_item_tmp = create_order_item_tmp index
    session[:order][index.to_i] = order_item_tmp
    check_duplicate index, order_item_tmp
    @order_tmp = session[:order]
    respond_to do |format|
      format.html{redirect_to order_path}
      format.js
    end
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

  def create_order_item_tmp index
    order_item_tmp = session[:order][index.to_i]
    order_item_tmp["quantity"] = order_item_params[:quantity].to_i
    order_item_tmp["selected_option_id"] = order_item_params[:option_id]
    order_item_tmp
  end

  def compare_item_cuisine? existing_order_item, order_item_tmp
    existing_order_item["cuisine"]["id"] == order_item_tmp["cuisine"]["id"]
  end

  def compare_item_option? existing_order_item, order_item_tmp
    existing_order_item["selected_option_id"] == order_item_tmp[
      "selected_option_id"]
  end

  def check_duplicate index, order_item_tmp
    session[:order].each_with_index do |existing_order_item, existing_index|
      next unless existing_index != index.to_i &&
                  compare_item_cuisine?(existing_order_item, order_item_tmp) &&
                  compare_item_option?(existing_order_item, order_item_tmp)

      existing_order_item["quantity"] += order_item_tmp["quantity"].to_i
      session[:order].delete_at(index.to_i)
      break
    end
  end
end
