class ChargeAction < ApplicationRecord
  belongs_to :charge
  enum type: { notice: 0, remind: 1, alert: 2 }
end
