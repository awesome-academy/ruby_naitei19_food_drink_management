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
