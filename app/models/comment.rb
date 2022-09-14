class Comment < ApplicationRecord
  include MultiImageable
  include TimeDisplayable

  belongs_to :user
  belongs_to :reactable, polymorphic: true
  has_many :photos, class_name: 'Image', as: :imageable, dependent: :destroy
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy

  alias_attribute :creator, :user
end
