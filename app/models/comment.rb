class Comment < ApplicationRecord
  include MultiImageable
  include TimeDisplayable
  after_create_commit :notify_creator

  belongs_to :user
  belongs_to :reactable, polymorphic: true
  has_one :comment_notification, 
          class_name: 'Notifications::CommentNotification', 
          as: :notifiable,
          dependent: :destroy
  has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy

  alias_attribute :creator, :user

  private

  def notify_creator
    create_comment_notification unless user == reactable.creator
  end
end
