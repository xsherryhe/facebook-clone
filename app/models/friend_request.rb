class FriendRequest < ApplicationRecord
  after_create_commit { create_friend_request_notification }

  validate :different_sender_receiver
  validate :not_already_friends, if: -> { pending? }

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_one :friend_request_notification,
          class_name: 'Notifications::FriendRequestNotification',
          as: :notifiable,
          dependent: :destroy
  has_one :friend_notification,
          class_name: 'Notifications::FriendNotification',
          as: :notifiable,
          dependent: :destroy

  enum :status, %i[pending accepted], default: :pending
  enum :view_status, %i[unviewed viewed], default: :unviewed, prefix: :friend_request

  scope :between, (lambda do |user1, user2|
    where(sender: user1, receiver: user2).or(where(sender: user2, receiver: user1))
  end)

  def accepted!
    create_friend_notification unless accepted?
    super
  end

  private

  def different_sender_receiver
    errors.add(:base, 'You cannot send a friend request to yourself!') if sender == receiver
  end

  def not_already_friends
    return unless sender.friends.include?(receiver)

    errors.add(:base, "You are already friends with #{receiver.profile.first_name}!")
  end
end
