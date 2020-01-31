class Bill < ApplicationRecord
  before_save :set_payment_due_date
  belongs_to :user
  has_many :charges, dependent: :destroy

  validates :category, presence: true
  monetize :price_cents, with_model_currency: :currency
  enum category: { foods: 0, shopping: 1, entertainment: 2, debt: 3, charge: 4, others: 5 }

  private

  def set_payment_due_date
    if payment_due_date.nil?
      self.payment_due_date = Date.current + 30
    else
      # jsのDatepickerの使用による対応
      self.payment_due_date += 1
    end
  end
end
