class Image < ApplicationRecord
  validate :url_xor_stored_present
  validates :stored, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg', 'image/svg'],
                                     message: 'is not an image (PNG, JPG, JPEG, or SVG)' }

  belongs_to :user
  belongs_to :imageable, polymorphic: true, optional: true
  has_one_attached :stored
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy
  has_many :descendant_likes, class_name: 'Like', as: :reactable_root, dependent: :destroy
  has_many :descendant_comments, class_name: 'Comment', as: :reactable_root, dependent: :destroy

  before_validation :delete_url_if_stored
  before_create :set_alt_text

  alias_attribute :creator, :user

  def source
    stored.attached? ? stored : url
  end

  def single_in_post?
    imageable.class.include?(MultiImageable) && imageable.single_photo?
  end

  def comment_name
    'comment'
  end

  def comment_form_first?
    true
  end

  def preview_comments?
    true
  end

  private

  def url_xor_stored_present
    return if (url && !stored.attached?) || (stored.attached? && !url)

    errors.add(:base, :url_or_stored_blank, message: 'Either URL or upload must be present')
  end

  def delete_url_if_stored
    self.url = nil if stored.attached?
  end

  def set_alt_text
    self.alt_text ||= 'A user-uploaded photo'
  end
end
