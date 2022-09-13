module ApplicationHelper
  def mini_avatar(profile)
    render profile.avatar, size: '35'
  end

  def full_avatar(profile)
    render profile.avatar, size: '250'
  end
end
