class Like < ApplicationRecord
  before_validation :set_reactable_root, unless: -> { reactable_root.present? }
  after_create_commit :notify_creator

  belongs_to :user
  belongs_to :reactable, polymorphic: true
  belongs_to :reactable_root, polymorphic: true
  has_one :like_notification,
          class_name: 'Notifications::LikeNotification',
          as: :notifiable,
          dependent: :destroy

  private

  def set_reactable_root
    root = reactable
    root = root.reactable while root.is_a? Comment
    self.reactable_root = root
  end

  def notify_creator
    create_like_notification unless user == reactable.creator
  end
end
