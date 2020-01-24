class Charge < ApplicationRecord
  belongs_to :bill
  belongs_to :friend
  has_many :charge_actions, dependent: :destroy

end
