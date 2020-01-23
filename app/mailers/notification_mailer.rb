class NotificationMailer < ApplicationMailer
  default from: "hogehoge@example.com"

  def send_mail_to_debtor(friend, user, bill)
    @friend = friend
    @user = user
    @bill = bill
    mail(
      subject: "#{@user.username}様より請求のお知らせ", #メールのタイトル
      to: @friend.email #宛先
    ) do |format|
      format.text
    end
  end 
end
