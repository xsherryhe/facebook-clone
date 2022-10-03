module MultiImageable
  extend ActiveSupport::Concern

  included do
    before_validation :set_raw_photos
    validate :valid_raw_photos
    validate :body_or_photo_present
    before_save :store_raw_photos

    has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
    accepts_nested_attributes_for :photos, allow_destroy: true
  end

  attr_accessor :raw_photos, :raw_photos_errors

  def single_photo?
    body.blank? && photos.size == 1
  end

  private

  def set_raw_photos
    self.raw_photos = (raw_photos || []) - ['']
    self.raw_photos_errors ||= []
  end

  def valid_raw_photos
    raw_photos.each.with_index(1) do |raw_photo, i|
      photo = Image.new(user: creator)
      photo.stored.attach(raw_photo)
      unless photo.valid?
        raw_photos_errors << [photo, i]
        errors.add(:base, :invalid_raw_photo, message: 'has invalid raw photo')
      end
    end
  end

  def body_or_photo_present
    return if body.present? ||
              raw_photos.any? ||
              photos.reject(&:marked_for_destruction?).any?

    errors.add(:body, "can't be blank")
  end

  def store_raw_photos
    raw_photos.each do |raw_photo|
      photos.build(user: creator).stored.attach(raw_photo)
    end
  end
end
