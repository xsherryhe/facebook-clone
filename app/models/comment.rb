class Comment < ApplicationRecord
  include MultiImageable
  include TimeDisplayable
  before_validation :set_reactable_root, unless: -> { reactable_root.present? }
  after_create_commit :notify_creator

  belongs_to :user
  belongs_to :reactable, polymorphic: true
  belongs_to :reactable_root, polymorphic: true
  has_one :comment_notification,
          class_name: 'Notifications::CommentNotification',
          as: :notifiable,
          dependent: :destroy
  has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy

  alias_attribute :creator, :user

  private

  def set_reactable_root
    root = reactable
    root = root.reactable while root.is_a? Comment
    self.reactable_root = root
  end

  def notify_creator
    create_comment_notification unless user == reactable.creator
  end
end
