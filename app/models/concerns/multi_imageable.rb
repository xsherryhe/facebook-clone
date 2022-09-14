module MultiImageable
  extend ActiveSupport::Concern

  included do
    before_validation :store_raw_photos
    validate :body_or_photo_present
  end

  attr_accessor :raw_photos

  private

  def store_raw_photos
    (raw_photos - ['']).each do |raw_photo|
      photos.build.stored.attach(raw_photo)
    end
  end

  def body_or_photo_present
    return if body.present? || (raw_photos - ['']).any?

    errors.add(:body, "can't be blank")
  end
end
