class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.newest if current_user
    render partial: "index", locals: {notifications: @notifications}
  end
end
