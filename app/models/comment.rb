class Comment < ApplicationRecord
  include TimeDisplayable

  validates :body, presence: true
  belongs_to :user
  belongs_to :reactable, polymorphic: true
  has_many :likes, as: :reactable, dependent: :destroy
  has_many :comments, as: :reactable, dependent: :destroy
end
