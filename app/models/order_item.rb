class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :cuisine
  belongs_to :option

  delegate :name, :slug, to: :cuisine, prefix: true, allow_nil: true
  delegate :name, :price, to: :option, prefix: true, allow_nil: true

  validates :quantity, presence: true,
    numericality: {only_integer: true,
                   greater_than: Settings.validates.order_items.quantity.min,
                   less_than: Settings.validates.order_items.quantity.max}
  validates :price, presence: true,
    numericality: {only_integer: true,
                   greater_than: Settings.validates.order_items.price.min,
                   less_than: Settings.validates.order_items.price.max}
end
