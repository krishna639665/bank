class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.limit(10).order(created_at: :desc)
  end
end
