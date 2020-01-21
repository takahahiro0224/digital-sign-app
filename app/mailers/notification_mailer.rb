class NotificationMailer < ApplicationMailer
  default from: "hogehoge@example.com"

  def send_notification_to_debtor(user)
    @user = user
    mail(
      subject: "テスト", #メールのタイトル
      to: @user.email #宛先
    ) do |format|
      format.text
    end
  end 
end
