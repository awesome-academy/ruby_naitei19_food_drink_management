class Category < ApplicationRecord
  acts_as_paranoid

  has_many :cuisines, dependent: :nullify

  def self.ransackable_attributes _auth_object = nil
    %w(created_at id name slug updated_at)
  end

  validates :name, presence: true,
length: {maximum: Settings.validates.categories.name.max_length}
  validates :slug, presence: true, uniqueness: true,
length: {maximum: Settings.validates.categories.slug.max_length}

  scope :sort_by_name, ->{order(name: :asc)}
  scope :by_slug, ->(slug){where(slug:)}
  scope :order_by_created_at, ->{order(created_at: :desc)}
end
