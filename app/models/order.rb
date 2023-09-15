class Order < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: {pending: 0, accepted: 1, rejected: 2}

  def self.ransackable_attributes _auth_object = nil
    %w(address phone sum created_at status)
  end

  validates :address, presence: true,
length: {maximum: Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
length: {maximum: Settings.validates.orders.phone.max_length}
  validates :status, presence: true
  validates :note, length: {maximum: Settings.validates.orders.note.max_length}

  scope :newest, ->{order(created_at: :desc)}
  scope :created_between, lambda {|start_date, end_date|
                            where(created_at: parsed_date(start_date)..
                            parsed_date(end_date))
                          }
  scope :filter_by_status, ->(status){status.present? ? where(status:) : all}

  class << self
    def parsed_date date_string
      DateTime.parse date_string
    end

    def statuses_i18n
      statuses.map{|k, v| [I18n.t("order.status.#{k}"), v]}
    end
  end
end
