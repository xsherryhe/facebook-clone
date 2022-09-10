class FriendRequest < ApplicationRecord
  validate :different_sender_receiver
  validate :not_already_friends, if: -> { pending? }

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  enum :status, %i[pending accepted]

  private

  def different_sender_receiver
    errors.add(:base, 'You cannot send a friend request to yourself!') if sender == receiver
  end

  def not_already_friends
    return unless sender.friends.include?(receiver)

    errors.add(:base, "You are already friends with #{receiver.profile.first_name}!")
  end
end
