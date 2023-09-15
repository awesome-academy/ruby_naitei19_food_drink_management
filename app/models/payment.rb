class Payment < ApplicationRecord
  belongs_to :order

  enum method: {cash: 0, credit_card: 1, paypal: 2}

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :method, presence: true, inclusion: {in: methods.keys}

  class << self
    def methods_i18n
      methods.map{|k, v| [I18n.t("payment.method.#{k}"), k, v]}
    end
  end
end
