class Post < ApplicationRecord
  validates :body, presence: true
  belongs_to :creator, class_name: 'User'
end
