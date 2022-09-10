class FriendRequest < ApplicationRecord
  validate :different_sender_receiver

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  enum :status, %i[pending accepted]

  private

  def different_sender_receiver
    errors.add(:base, 'You cannot send a friend request to yourself!') if sender == receiver
  end
end
