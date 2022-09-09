class Image < ApplicationRecord
  validate :url_xor_stored_present
  belongs_to :imageable, polymorphic: true, optional: true

  before_validation :delete_url_if_stored

  # Remove later
  def stored
    nil
  end

  def source
    stored || url
  end

  private

  def url_xor_stored_present
    return if (url && !stored) || (stored && !url)

    errors.add(:base, :url_or_stored_blank, message: 'URL or upload must be present')
  end

  def delete_url_if_stored
    this.url = nil if stored
  end
end
