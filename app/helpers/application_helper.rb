module ApplicationHelper
  def resource_name(resource)
    resource.class.name.downcase
  end

  def mini_avatar(profile, link_path = user_path(profile.user))
    render profile.avatar, link_path:, size: '35'
  end

  def full_avatar(profile, link_path = image_path(profile.avatar))
    render profile.avatar, link_path:, size: '250'
  end
end
