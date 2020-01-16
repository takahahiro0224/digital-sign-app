class User < ApplicationRecord
  has_many :bills

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true
end
