class Bill < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  monetize :price_cents, with_model_currency: :currency
end
