module MachineLearning
  class CreditScore

    def initialize(friend)
      @friend = friend
    end

    def calcurate
      score = 100
      charges = Charge.where(friend_id: @friend.id)

      charges.each do |charge|
        if charge.paid
          if charge.paid_at.to_datetime > (charge.bill.payment_due_date+1).to_datetime
            time_diff = charge.paid_at.to_time -  (charge.bill.payment_due_date+1).to_time
            hour_diff = time_diff/60/60
            score -= hour_diff * 0.2
          else
            score =+ 6
          end
        end

        comment_scores = 0
        response_cnt = 0
        charge.charge_actions do |charge_action|
          comment_scores = 0
          respnose_cnt = 0
          if  response = charge_action.charge_action_response
            response_cnt += 1
            comment_scores += (1+response.comment_score)**2 *(1+response.comment_magnitude)
          end
        end

        if response_cnt > 0
          score += comment_scores / response_cnt
        end
      end
      score.floor
    end

  end
end
