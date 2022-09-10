class Image < ApplicationRecord
  validate :url_xor_stored_present
  validates :stored, content_type: { in: ['image/png', 'image/jpg', 'image/jpeg', 'image/svg'],
                                     message: 'is not an image (PNG, JPG, JPEG, or SVG)' }
  belongs_to :imageable, polymorphic: true, optional: true
  has_one_attached :stored

  before_validation :delete_url_if_stored

  def source
    stored.attached? ? stored : url
  end

  private

  def url_xor_stored_present
    return if (url && !stored.attached?) || (stored.attached? && !url)

    errors.add(:base, :url_or_stored_blank, message: 'Either URL or upload must be present')
  end

  def delete_url_if_stored
    self.url = nil if stored.attached?
  end
end
