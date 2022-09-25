class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.for_display.with_associations.limit(15).order(created_at: :desc)
    @new_notifications = @notifications.notification_unviewed.to_a
    @notifications.each(&:notification_viewed!)
  end
end
