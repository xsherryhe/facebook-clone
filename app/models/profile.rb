class Profile < ApplicationRecord
  before_create :add_avatar

  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :user
  has_one :avatar, class_name: 'Image', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(' ')
  end

  def birthdate_full_display
    birthdate&.strftime('%B %-d, %Y')
  end

  private

  def add_avatar
    build_avatar(url: gravatar_default_url, alt_text: "#{first_name}'s profile picture")
  end

  def gravatar_default_url
    hash = Digest::MD5.hexdigest(user.email || '')
    "https://www.gravatar.com/avatar/#{hash}?default=identicon&size=150"
  end
end
