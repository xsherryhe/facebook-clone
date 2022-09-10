class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]
  validates :username, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_.#!$*?]*\Z/,
                                 message: 'contains a disallowed character' },
                       allow_nil: true
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#@{}()+-=!$%\^&*?]).*\Z/,
                                 message: 'must contain at least 1 of each: ' \
                                          'uppercase letter, lowercase letter, digit, symbol' },
                       allow_blank: true
  validates :profile, presence: true
  validate :uid_or_email_present

  has_one :profile, dependent: :destroy
  has_and_belongs_to_many :friends, class_name: 'User',
                                    foreign_key: 'user_id',
                                    association_foreign_key: 'friend_id',
                                    join_table: 'friendships'
  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :created_posts, class_name: 'Post', foreign_key: 'creator_id', dependent: :destroy
  accepts_nested_attributes_for :profile

  attr_writer :login

  def strangers
    User.where.not(id: [id] + sent_friend_requests.pluck(:receiver_id) + friends.pluck(:friend_id))
  end

  def add_friend(friend)
    friends << friend
    friend.friends << self
  end

  def login
    @login || username || email
  end

  def native_login?
    email.present? && password.present?
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = generate_password
      user.build_profile_from_omniauth(auth)
    end
  end

  def self.generate_password
    SecureRandom.base64(10) +
      [('A'..'Z'), ('a'..'z'), ('0'..'9'), '!@#$%^&*()?'.chars]
      .map { |set| set.to_a.sample }.shuffle.join
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['info'])
        user.email = data['email']
      end
    end
  end

  def build_profile_with_session(params, session)
    build_profile(params).tap do |profile|
      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['info'])
        %w[first_name middle_name last_name location birthdate].each do |attribute|
          profile[attribute.to_sym] = data[attribute]
        end
      end
    end
  end

  def build_profile_from_omniauth(auth)
    build_profile(first_name: auth.info.first_name,
                  middle_name: auth.info.middle_name,
                  last_name: auth.info.last_name,
                  birthdate: auth.dig(:extra, :raw_info, :birthday),
                  location: auth.dig(:extra, :raw_info, :location, :name))
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    attributes = %i[username email]
    attributes.each do |attribute|
      conditions[attribute].downcase! if conditions[attribute]
    end
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value',
                                   { value: login.downcase }]).first
    elsif attributes.any? { |attribute| conditions.has_key?(attribute) }
      find_by(conditions.to_h)
    end
  end

  private

  def email_required?
    false
  end

  def uid_or_email_present
    errors.add(:email, "can't be blank") if email.blank? && (provider.blank? || uid.blank?)
  end
end
