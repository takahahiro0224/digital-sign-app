class User < ApplicationRecord
  has_many :bills, dependent: :destroy
  has_many :friends, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true
end
