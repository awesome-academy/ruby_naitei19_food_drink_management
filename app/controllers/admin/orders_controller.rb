class Admin::OrdersController < ApplicationController
  layout "admin"

  before_action :find_order, only: %i(update)

  def index
    @q = Order.ransack(params[:q])
    @pagy, @orders = pagy(@q.result(distinct: true).newest)
  end

  def update
    if @order.update order_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to admin_orders_path
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def find_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t ".not_found"
    redirect_to admin_orders_path
  end
end
