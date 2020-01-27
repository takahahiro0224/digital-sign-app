class ChargeAction < ApplicationRecord
  before_save :generate_token

  belongs_to :charge
  has_one :charge_action_response
  enum action_type: { notice: 0, remind: 1, alert: 2 }

  private
    
    def generate_token
      if token.nil?
        self.token = SecureRandom.urlsafe_base64
      end
    end
end
