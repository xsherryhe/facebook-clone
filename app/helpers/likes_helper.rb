module LikesHelper
  def users_detail(likes)
    users = likes.map(&:user)
    other_users = users - [current_user]
    friends, strangers = other_users.partition do |user|
      current_user.friends.include?(user)
    end
    (friends + [current_user]).empty? ? '' : ": #{detail_text(users, other_users, friends, strangers)}"
  end

  private

  def detail_text(users, other_users, friends, strangers)
    ((users.include?(current_user) ? ['You'] : []) +
      if users.size <= 3
        other_users.map { |user| user.profile.full_name }
      else
        friends.map { |friend| friend.profile.full_name } +
        (strangers.any? ? [pluralize(strangers.size, 'other')] : [])
      end).to_sentence
  end
end
