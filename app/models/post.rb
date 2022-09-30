class Post < ApplicationRecord
  include TimeDisplayable
  include MultiImageable

  belongs_to :creator, class_name: 'User'
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy
  has_many :descendant_likes, class_name: 'Like', as: :reactable_root, dependent: :destroy
  has_many :descendant_comments, class_name: 'Comment', as: :reactable_root, dependent: :destroy

  scope :up_to_page, (lambda do |page|
    limit(page * 10)
  end)

  def comment_name
    'comment'
  end

  def comment_form_first?
    true
  end

  def preview_comments?
    true
  end
end
