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
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy

  alias_attribute :creator, :user

  scope :with_associations, (lambda do
    includes({ reactable: :comments }, { user: :profile }, { likes: { user: :profile } }, :comments, :photos)
  end)

  scope :up_to_page, (lambda do |page|
    with_associations.order(created_at: :asc).limit(page * 8)
  end)

  scope :preview, (lambda do
    with_associations.order(created_at: :asc).limit(2)
  end)

  def self.all_displayed?(comments)
    return true if comments.empty?

    comments.size == comments.first.reactable.comments.where.not(id: nil).size
  end

  def comment_name
    'reply'
  end

  def comment_form_first?
    false
  end

  def preview_comments?
    false
  end

  private

  def set_reactable_root
    self.reactable_root = (reactable.is_a?(Comment) ? reactable.reactable_root : reactable)
  end

  def notify_creator
    create_comment_notification unless user == reactable.creator
  end
end
