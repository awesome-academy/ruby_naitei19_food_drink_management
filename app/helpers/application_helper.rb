module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title
    base_title = Settings.app_name
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def show_errors object, field_name
    return unless object.errors.any?

    return if object.errors.messages[field_name].blank?

    object.errors.full_messages_for(field_name)[0]
  end

  def user_avatar user
    if user.avatar.attached?
      user.avatar
    else
      "default-avatar.png"
    end
  end
end
