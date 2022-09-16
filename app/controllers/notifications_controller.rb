class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.for_display.with_associations.order(created_at: :desc)
    @notifications.each(&:notification_viewed!)
  end

  private

  def create_group_notifications
    current_user.notifications.with_associations.select(&:groupable?)
                .group_by { |notification| [notification.type, notification.notifiable.reactable] }
                .each do |_, single_notifications|
                  next if single_notifications.size == 1

                  group_notification = Notifications::GroupNotification.new
                  group_notification.notifications = single_notifications
                  group_notification.save
                end
  end
end
