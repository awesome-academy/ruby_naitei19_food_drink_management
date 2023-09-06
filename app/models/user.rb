class User < ApplicationRecord
  before_save :downcase_email

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :first_name, presence: true,
          length: {maximum: Settings.validates.users.name.max_length}
  validates :last_name, presence: true,
          length: {maximum: Settings.validates.users.name.max_length}
  validates :email, presence: true, uniqueness: true,
            format: {with: Settings.validates.users.email.format},
            length: {maximum: Settings.validates.users.email.max_length}
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
