class Admin::DashboardController < Admin::BaseController
  def show
    dashboard_service = DashboardMetricsService.new

    @this_month_revenue,
    @last_month_revenue,
    @percent_revenue = dashboard_service.calculate_revenue_metrics

    @this_month_orders,
    @last_month_orders,
    @percent_orders = dashboard_service.calculate_order_metrics
    @this_month_new_users,
    @last_month_new_users,
    @percent_new_users = dashboard_service.calculate_new_user_metrics
    @total_revenue = Order.sum(:sum)
    @order_item_group_by_category_of_cuisine =
      dashboard_service.calculate_order_item_group_by_category
    @order_item_group_by_cuisine =
      dashboard_service.calculate_order_item_group_by_cuisine
    @revenue_group_by_month =
      dashboard_service.calculate_revenue_group_by_month
    @top_5_cuisines_by_quantity =
      dashboard_service.calculate_top_cuisines_by_quantity
    @top_5_cuisines_by_revenue =
      dashboard_service.calculate_top_cuisines_by_revenue
  end
end
