module OrderHelper
  def calculate_total_price order
    order.sum do |order_item|
      cuisine_price = order_item["cuisine"]["price"]
      option_prices = order_item["selected_option_ids"].map do |option_id|
        option = Option.find_by(id: option_id)
        option&.price.to_i
      end.compact.sum

      cuisine_price + option_prices
    end
  end
end
