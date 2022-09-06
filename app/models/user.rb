class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = generate_password
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
end
