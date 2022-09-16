class Like < ApplicationRecord
  after_create_commit :notify_creator

  belongs_to :user
  belongs_to :reactable, polymorphic: true
  has_one :like_notification,
          class_name: 'Notifications::LikeNotification',
          as: :notifiable,
          dependent: :destroy

  private

  def notify_creator
    create_like_notification unless user == reactable.creator
  end
end
