class Review < ApplicationRecord
  belongs_to :user
  belongs_to :cuisine

  validates :star, presence: true,
numericality: {only_integer: true,
               greater_than: Settings.validates.reviews.star.min,
               less_than: Settings.validates.reviews.star.max}
  validates :comment, presence: true,
length: {maximum: Settings.validates.reviews.comment.max_length}
end
