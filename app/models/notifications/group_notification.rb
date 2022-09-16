class Notifications::GroupNotification < Notification
  before_validation :set_notifiable, unless: -> { notifiable }

  validates :notifications, presence: true
  has_many :notifications, foreign_key: 'group_id'

  scope :with, (lambda do |user, type, dimension|
    where(user:).select { |group| group.type == type && group.dimension == dimension }
  end)

  def notification_viewed!
    notifications.each(&:notification_viewed!)
    super
  end

  def initiator_name
    notifications.map(&:initiator_name).to_sentence
  end

  def initiator_action
    notifications.first.initiator_action
  end

  def link
    notifications.first.link
  end

  def dimension
    notifications.first.group_dimension
  end

  def type
    notifications.first.type
  end

  private

  def set_user
    self.user = notifications.first.user
  end

  def set_notifiable
    self.notifiable = notifications.first.notifiable
  end
end
