class Bill < ApplicationRecord
  belongs_to :user

  monetize :price_cents, with_model_currency: :currency
end
