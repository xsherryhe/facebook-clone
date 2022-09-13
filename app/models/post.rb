class Post < ApplicationRecord
  include TimeDisplayable
  include MultiImageable

  validates :body, presence: true
  belongs_to :creator, class_name: 'User'
  has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy
end
