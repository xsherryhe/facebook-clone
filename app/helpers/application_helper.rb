module ApplicationHelper
  def mini_avatar(user)
    image_tag user.profile.avatar.source, alt: user.profile.avatar.alt_text, size: '35'
  end
end
