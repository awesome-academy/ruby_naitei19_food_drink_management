class Option < ApplicationRecord
  belongs_to :cuisine

  validates :name, presence: true,
    length: {maximum: Settings.validates.options.name.max_length}
  validates :price, presence: true,
    numericality: {only_integer: true,
                   greater_than: Settings.validates.options.price.min,
                   less_than: Settings.validates.options.price.max}
end
