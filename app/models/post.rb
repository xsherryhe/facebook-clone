class Post < ApplicationRecord
  include TimeDisplayable
  include MultiImageable

  belongs_to :creator, class_name: 'User'
  has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy
end
