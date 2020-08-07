class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail(to: @user.email, subject: I18n.t("home.app"))
  end
end
