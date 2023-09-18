class Notification < ApplicationRecord
  belongs_to :recipient, class_name: User.name

  validates :title, presence: true,
                    length: {maximum: Settings.validates.notifications
                                              .title.max_length}
  validates :content, presence: true,
                      length: {maximum: Settings.validates.notifications
                                                .content.max_length}

  after_save :send_to_user

  scope :newest, ->{order(created_at: :desc)}

  private
  def send_to_user
    html = ApplicationController.render partial: "notifications/notification",
                                        locals: {notification: self},
                                        formats: [:html]
    ActionCable.server.broadcast(
      "notifications_#{recipient_id}",
      {html:}
    )
  end
end
