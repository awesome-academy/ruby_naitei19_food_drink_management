class Cuisine < ApplicationRecord
  belongs_to :category
  has_many :options, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validates.cuisines.name.max_length}
  validates :slug, presence: true, uniqueness: true,
    length: {maximum: Settings.validates.cuisines.slug.max_length}
  validates :description, presence: true,
    length: {maximum: Settings.validates.cuisines.description.max_length}
  validates :price, presence: true,
    numericality: {only_integer: true,
                   greater_than: Settings.validates.cuisines.price.min,
                   less_than: Settings.validates.cuisines.price.max}
end
