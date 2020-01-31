namespace :auto_mail do
  desc "リマインド、アラートメールの送信"
  task run: :environment do
    target_bills = Bill.where(paid: false).where(auto_mail: true)
    today = Date.current

    target_bills.each do |bill|
      due_date = bill.payment_due_date

      # 支払い期限日の前日に送信
      if (due_date - today).to_i == 1
         charges = bill.charges.select {|c| c.paid == false}
         charges.each do |charge|
           action = ChargeAction.new(action_type: 'remind')
           action.charge = charge
           action.save

           
           NotificationMailer.send_remind_to_friend(charge.friend, bill, action).deliver
           puts "sent remind mail"
        

         end
         next
      end

      # 支払い期限日の3日後から3日毎に送信
      if (today - due_date) > 1 && (today - due_date) % 3 == 1
        charges = bill.charges.select {|c| c.paid == false}
        charges.each do |charge|
          action = ChargeAction.new(action_type: 'alert')
          action.charge = charge
          action.save


          NotificationMailer.send_alert_to_friend(charge.friend, bill, action).deliver
          puts "sent alert mail"

        end
      end

    end
  end
end
