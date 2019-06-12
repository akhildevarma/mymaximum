class SignupMailer < ApplicationMailer
  layout false

  def welcome(user)
    @name = user.decorate.name
    @is_provider = user.provider?
    
    if @is_provider
      Notification.create(user: user, sent_via: Notification::EMAIL, referenceable: user, notification_type: Notification::SECOND_WELCOME)
    end

    mail(to: user.email, subject: I18n.t('signup.welcome_subject'))
  end

  def secondary_welcome(user)
    if user.present?
      @name = user.decorate.name
      @is_provider = user.provider?
      mail(to: user.email, subject: "Re: #{I18n.t('signup.welcome_subject')}")
    end
  end

  def third_welcome(user)
    mail(to: user.email, subject: "Re: #{I18n.t('signup.welcome_subject')}")
  end

  def fourth_welcome(user)
    @name = user.decorate.name
    mail(to: user.email, from: '"InpharmD™" <Ashish@inpharmd.com>', subject: "Re: #{I18n.t('signup.fourth_welcome_subject')}")
  end

  def signup_automated_email_1(user, email_list)
    @unsubscribe = email_list.group
    @user = user
    mail(to: user.email, subject: "How can InpharmD™ Help?")
  end

  def signup_automated_email_2(user, email_list)
    @unsubscribe = email_list.group
    @user = user
    mail(to: user.email, subject: "MME calculator, quick and easy.")
  end

  def signup_automated_email_3(user, email_list)
    @unsubscribe = email_list.group
    @user = user
    mail(to: user.email, subject: "Your questions answered any time, anywhere")
  end

  def signup_automated_email_4(user, email_list)
    @unsubscribe = email_list.group
    @user = user
    mail(to: user.email, subject: "How we answer your questions")
  end

  # def signup_automated_email_5(user)
  #   @user = user
  #   mail(to: user.email, subject: "We're all connected!")
  # end

  # def signup_automated_email_6(user)
  #   @user = user
  #   mail(to: user.email, subject: "They’re giving me what I need so that I can make my decision.")
  # end

  # def signup_automated_email_7(user)
  #   @user = user
  #   mail(to: user.email, subject: "What they’re saying about us")
  # end

  # def signup_automated_email_8(user)
  #   @user = user
  #   mail(to: user.email, from: '"InpharmD™" <Ashish@inpharmd.com>', subject: "Re: Welcome to InpharmD™")
  # end
end
