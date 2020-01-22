class Bill < ApplicationRecord
  belongs_to :user
  has_many :debtor

  validates :title, presence: true
  monetize :price_cents, with_model_currency: :currency
end
