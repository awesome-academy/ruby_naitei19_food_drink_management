class Cuisine < ApplicationRecord
  belongs_to :category
  has_many :options, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :image

  def self.ransackable_attributes _auth_object = nil
    %w(name description price category_id)
  end

  delegate :name, to: :category, prefix: true

  scope :order_by_created_at, ->{order(created_at: :desc)}

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
