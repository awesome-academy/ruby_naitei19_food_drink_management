class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  enum status: {pending: 0, accepted: 1, rejected: 2}

  validates :address, presence: true,
length: {maximum: Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
length: {maximum: Settings.validates.orders.phone.max_length}
  validates :status, presence: true
  validats :note, length: {maximum: Settings.validates.orders.note.max_length}
end
