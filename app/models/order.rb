class Order < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  accepts_nested_attributes_for :payment

  enum status: {pending: 0, accepted: 1, rejected: 2, cancelled: 3}

  def self.ransackable_attributes _auth_object = nil
    %w(address phone sum created_at status)
  end

  delegate :email, :first_name, :last_name, to: :user, prefix: true,
allow_nil: true

  validates :address, presence: true,
length: {maximum: Settings.validates.orders.address.max_length}
  validates :phone, presence: true,
length: {maximum: Settings.validates.orders.phone.max_length}
  validates :status, presence: true
  validates :note, length: {maximum: Settings.validates.orders.note.max_length}

  after_update :send_notification, if: :saved_change_to_status?

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

  private
  def send_notification
    new_status = saved_change_to_status[1]
    if new_status == "accepted"
      accept_order
    elsif new_status == "rejected"
      reject_order
    end
  end

  def accept_order
    user.notifications
        .create title: I18n.t(".notifications.accept_order.title"),
                content: I18n.t(".notifications.accept_order.content")
  end

  def reject_order
    user.notifications
        .create title: I18n.t(".notifications.reject_order.title"),
                content: I18n.t(".notifications.reject_order.content")
  end
end
