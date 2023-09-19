class Cuisine < ApplicationRecord
  acts_as_paranoid

  belongs_to :category
  has_many :options, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_one_attached :image

  def self.ransackable_attributes _auth_object = nil
    %w(name description price category_id)
  end

  scope :order_by_created_at, ->{order(created_at: :desc)}

  # Delegate category_name from category to Cuisine
  delegate :name, to: :category, prefix: true, allow_nil: true

  validates :image,
            content_type: {in: Settings.config.image.acceptable_types,
                           message: I18n.t("cuisines.must_be_a_PNG_JPG_JPEG")},
                              size: {less_than: Settings
                                .config
                                .image.max_size
                                .megabytes,
                                     message: I18n.t("cuisines.is_too_big")}

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
