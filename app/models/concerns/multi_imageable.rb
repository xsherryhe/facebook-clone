module MultiImageable
  extend ActiveSupport::Concern

  included do
    before_validation :store_raw_photos
    validate :body_or_photo_present

    has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
    accepts_nested_attributes_for :photos, allow_destroy: true
  end

  attr_accessor :raw_photos

  def single_photo?
    body.blank? && photos.size == 1
  end

  private

  def store_raw_photos
    ((raw_photos || []) - ['']).each do |raw_photo|
      photos.build(user: creator).stored.attach(raw_photo)
    end
  end

  def body_or_photo_present
    return if body.present? || photos.any?

    errors.add(:body, "can't be blank")
  end
end
