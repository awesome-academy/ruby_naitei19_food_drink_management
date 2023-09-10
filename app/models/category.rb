class Category < ApplicationRecord
  has_many :cuisines, dependent: :nullify

  validates :name, presence: true,
length: {maximum: Settings.validates.categories.name.max_length}
  validates :slug, presence: true, uniqueness: true,
length: {maximum: Settings.validates.categories.slug.max_length}

  scope :sort_by_name, ->{order(name: :asc)}
end
