class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i(update show)

  def index
    @q = Order.ransack(params[:q])
    @pagy, @orders = pagy(@q.result(distinct: true).newest)
  end

  def show
    @order_items = @order.order_items
    @user = @order.user
  end

  def update
    if @order.update order_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to admin_orders_path
  end

  def excel
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @user = @order.user
    respond_to do |format|
      format.xlsx do
        render xlsx: "export_order",
               filename: "order-#{@order.id}.xlsx"
      end
    end
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
