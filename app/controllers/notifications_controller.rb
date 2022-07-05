class NotificationsController < ApplicationController
  def index
    @pagy, @activities = pagy(PublicActivity::Activity.all, items: 10)
  end
end
