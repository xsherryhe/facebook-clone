class Notification < ApplicationRecord
  include Rails.application.routes.url_helpers

  before_validation :set_user, unless: -> { user }
  after_create :add_to_group
  after_destroy :destroy_empty_group

  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :group, class_name: 'Notifications::GroupNotification', optional: true

  enum :view_status, %i[unviewed viewed], default: :unviewed, prefix: :notification

  scope :for_display, -> { where(group: nil) }
  scope :with_associations, (lambda do
    includes(notifiable: [{ sender: :profile },
                          { receiver: :profile },
                          { user: :profile },
                          :reactable])
  end)

  def initiator_name
    initiator.profile.full_name
  end

  def body
    "#{initiator_name} #{initiator_action}."
  end

  def groupable?
    false
  end

  protected

  def set_user
    self.user = notifiable.user
  end

  def reactable_model_name
    notifiable.reactable.model_name.human.downcase
  end

  def reactable_model_singular_route_key
    notifiable.reactable.model_name.singular_route_key
  end

  def add_to_group
    return unless groupable?

    target_group = Notifications::GroupNotification.with(user, type, group_dimension).first ||
                   Notifications::GroupNotification.new
    target_group.notifications << self
    target_group.notification_unviewed!
    target_group.save
  end

  def destroy_empty_group
    return unless groupable? && group

    group.destroy if group.notifications.empty?
  end
end
