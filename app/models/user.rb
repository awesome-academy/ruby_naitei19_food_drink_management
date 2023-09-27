class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_save :downcase_email

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one_attached :avatar
  has_many :notifications, as: :recipient, dependent: :destroy

  enum role: {admin: 0, user: 1}

  validates :first_name, presence: true,
          length: {maximum: Settings.validates.users.name.max_length}
  validates :last_name, presence: true,
          length: {maximum: Settings.validates.users.name.max_length}
  validates :email, presence: true, uniqueness: true,
            format: {with: Settings.validates.users.email.format},
            length: {maximum: Settings.validates.users.email.max_length}
  validates :avatar, content_type: {in: Settings.validates.users.image_type,
                                    message: :invalid_image_type},
                    size: {less_than: 5.megabytes, message: :limit_size}

  private
  def downcase_email
    email.downcase!
  end
end
