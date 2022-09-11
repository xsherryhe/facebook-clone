class Post < ApplicationRecord
  include TimeDisplayable

  validates :body, presence: true
  belongs_to :creator, class_name: 'User'
  has_many :comments, as: :reactable, dependent: :destroy
end
