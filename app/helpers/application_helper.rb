module ApplicationHelper
  def mini_avatar(profile)
    image_tag profile.avatar.source, alt: profile.avatar.alt_text, size: '35'
  end

  def full_avatar(profile)
    image_tag profile.avatar.source, alt: profile.avatar.alt_text, size: '250'
  end
end
