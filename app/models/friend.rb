class Friend < ApplicationRecord
  belongs_to :user
  has_many :charges, dependent: :destroy

  validates :name, :email, presence: true
end
