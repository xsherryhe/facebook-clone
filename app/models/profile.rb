class Profile < ApplicationRecord
  before_validation :set_privacy
  before_create :add_avatar

  validates :first_name, presence: true
  validates :last_name, presence: true
  serialize :privacy

  belongs_to :user
  has_one :avatar, class_name: 'Image', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :avatar

  attr_accessor :birthdate_public, :location_public

  def full_name
    [first_name, middle_name, last_name].select(&:present?).join(' ')
  end

  def birthdate_full_display
    birthdate&.strftime('%B %-d, %Y')
  end

  def set_to_public?(attribute)
    privacy[attribute.to_s] == 1
  end

  def set_to_private?(attribute)
    privacy[attribute.to_s] == 0
  end

  private

  def add_avatar
    build_avatar(url: gravatar_default_url, alt_text: "#{first_name}'s profile picture", user:)
  end

  def gravatar_default_url
    hash = Digest::MD5.hexdigest(user.email || '')
    "https://www.gravatar.com/avatar/#{hash}?default=identicon&size=150"
  end

  def set_privacy
    self.privacy ||= { 'first_name' => 1, 'middle_name' => 1, 'last_name' => 1,
                       'birthdate' => 0, 'location' => 0 }

    %w[birthdate location].each do |attribute|
      setting = public_send("#{attribute}_public")
      next unless setting

      self.privacy[attribute] = setting.to_i
    end
  end
end
