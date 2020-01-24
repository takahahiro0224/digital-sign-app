class Bill < ApplicationRecord
  belongs_to :user
  has_many :debtor, dependent: :destroy

  validates :category, presence: true
  monetize :price_cents, with_model_currency: :currency
  enum category: { foods: 0, shopping: 1, entertainment: 2, debt: 3, charge: 4, others: 5 }
end
