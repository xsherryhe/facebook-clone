class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :validatable
end
