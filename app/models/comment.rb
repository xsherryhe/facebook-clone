class Comment < ApplicationRecord
  include TimeDisplayable

  validates :body, presence: true
  belongs_to :user
  belongs_to :reactable, polymorphic: true
  has_many :comments, as: :reactable, dependent: :destroy
end
