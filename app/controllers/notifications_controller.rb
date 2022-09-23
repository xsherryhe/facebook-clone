class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.for_display.with_associations.limit(10).order(created_at: :desc)
    @notifications.each(&:notification_viewed!)
  end
end
