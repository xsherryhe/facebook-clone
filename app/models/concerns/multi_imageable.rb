module MultiImageable
  extend ActiveSupport::Concern

  included do
    before_validation :store_raw_photos
  end

  attr_accessor :raw_photos

  private

  def store_raw_photos
    (raw_photos - ['']).each do |raw_photo|
      photos.build(alt_text: 'A user-uploaded photo').stored.attach(raw_photo)
    end
  end
end
