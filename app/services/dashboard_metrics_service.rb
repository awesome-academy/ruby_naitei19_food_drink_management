class DashboardMetricsService
  def initialize; end

  def calculate_revenue_metrics
    this_month = Time.zone.now.beginning_of_month
    last_month = this_month - 1.month

    this_month_revenue = Order.where("created_at >= ?", this_month).sum(:sum)
    last_month_revenue = Order.where("created_at >= ? AND created_at < ?",
                                     last_month, this_month).sum(:sum)
    percent_revenue =
      ((this_month_revenue - last_month_revenue) /
      last_month_revenue.to_f * 100).round(2)

    [this_month_revenue, last_month_revenue, percent_revenue]
  end

  def calculate_order_metrics
    this_month = Time.zone.now.beginning_of_month
    last_month = this_month - 1.month

    this_month_orders = Order.where("created_at >= ?", this_month).count
    last_month_orders =
      Order.where("created_at >= ? AND created_at < ?",
                  last_month, this_month).count
    percent_orders =
      ((this_month_orders - last_month_orders) /
      last_month_orders.to_f * 100).round(2)

    [this_month_orders, last_month_orders, percent_orders]
  end

  def calculate_new_user_metrics
    this_month = Time.zone.now.beginning_of_month
    last_month = this_month - 1.month

    this_month_new_users = User.where("created_at >= ?", this_month).count
    last_month_new_users = User.where("created_at >= ? AND created_at < ?",
                                      last_month, this_month).count
    percent_new_users =
      ((this_month_new_users - last_month_new_users) /
      last_month_new_users.to_f * 100).round(2)

    [this_month_new_users, last_month_new_users, percent_new_users]
  end

  def calculate_order_item_group_by_category
    OrderItem.joins(cuisine: :category)
             .group("categories.name")
             .sum(:sum).first(5)
  end

  def calculate_order_item_group_by_cuisine
    OrderItem.joins(:cuisine).group("cuisines.name").sum(:sum).first(5)
  end

  def calculate_revenue_group_by_month
    Order.group_by_month(:created_at).sum(:sum)
  end

  def calculate_top_cuisines_by_quantity
    top_cuisines = Cuisine.joins(:order_items)
                          .group("cuisines.id")
                          .sum("order_items.quantity")
                          .sort_by do |_, v|
      -v
    end.first(5)
    top_cuisines.map do |cuisine_id, quantity|
      [Cuisine.find(cuisine_id), quantity]
    end
  end

  def calculate_top_cuisines_by_revenue
    top_cuisines = Cuisine.joins(:order_items)
                          .group("cuisines.id")
                          .sum("order_items.sum")
                          .sort_by do |_, v|
      -v
    end.first(5)
    top_cuisines.map do |cuisine_id, revenue|
      [Cuisine.find(cuisine_id), revenue]
    end
  end
end
