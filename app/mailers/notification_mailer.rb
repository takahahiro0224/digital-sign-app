class NotificationMailer < ApplicationMailer
  default from: "hogehoge@example.com"

  def send_mail_to_friend(friend, bill, action)
    @friend = friend
    @user = bill.user
    @bill = bill
    @charge_action = action
    mail(
      subject: "#{@user.username}様より請求のお知らせ", #メールのタイトル
      to: @friend.email #宛先
    ) do |format|
      format.text
    end


  end
  
  def send_remind_to_friend
  end

  def send_alert_to_friend
  end
end
