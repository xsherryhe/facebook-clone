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

  attr_writer :login

  def login
    @login || username || email
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = generate_password
      # Code to create and populate user profile -- use user.create_profile
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

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    attributes = %i[username email]
    attributes.each do |attribute|
      conditions[attribute].downcase! if conditions[attribute]
    end
    if(login = conditions[:login].delete)
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value',
                                   { value: login.downcase }]).first
    elsif attributes.any? { |attribute| conditions.has_key?(attribute) }
      find_by(conditions.to_h)
    end
  end
end
