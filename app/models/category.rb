class Category < ApplicationRecord
  has_many :cuisines, dependent: :nil

  validates :name, presence: true,
length: {maximum: Settings.validates.categories.name.max_length}
  validates :slug, presence: true, uniqueness: true,
length: {maximum: Settings.validates.categories.slug.max_length}
end
