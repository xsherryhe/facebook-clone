class Notifications::GroupNotification < Notification
  before_validation :set_notifiable, unless: -> { notifiable.present? }

  validates :notifications, presence: true
  has_many :notifications, foreign_key: 'group_id', dependent: :destroy

  scope :with, (lambda do |user, type, dimension|
    where(user:).select { |group| group.type == type && group.dimension == dimension }
  end)

  def notification_viewed!
    notifications.each(&:notification_viewed!)
    super
  end

  def initiator_name
    (if notifications.size <= 2
       notifications.map(&:initiator_name)
     else
       [notifications.first.initiator_name, "#{notifications.size - 1} others"]
     end).to_sentence
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
