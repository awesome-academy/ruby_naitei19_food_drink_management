class OrdersController < ApplicationController
  before_action :logged_in_user, only: :index
  before_action :search_params, only: :index

  def index
    @orders = current_user.orders
                          .created_between(@search_params[:from_date],
                                           @search_params[:to_date])
                          .filter_by_status params[:status]
    @pagy, @orders = pagy(@orders.newest,
                          items: Settings.config.pagination.orders_per_page)
  end

  def show
    @order = session[:order]
    return if @order

    flash[:danger] = t "order.no_order"
    redirect_to root_path
  end

  def delete_item
    index = params[:index].to_i
    if session[:order] && index >= 0 && index < session[:order].length
      session[:order].delete_at(index)
      @order = session[:order]
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def delete
    if session.delete(:order)
      @order = nil
      flash[:success] = t "order.delete_success"
      redirect_to root_path
    else
      flash[:danger] = t "order.delete_fail"
    end
  end

  private
  def search_params
    @search_params = params
                     .permit(:status, :from_date, :to_date)
                     .with_defaults(
                       from_date: Time.zone.now.prev_month.strftime("%Y-%m-%d"),
                       to_date: Time.zone.now.strftime("%Y-%m-%d")
                     )
  end
end
