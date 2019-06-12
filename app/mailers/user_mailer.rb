class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: I18n.t('password_reset.subject'), mail_type: :password_reset
  end

  def activate_other_email(user_email)
    @url = email_activation_url(token: user_email.activation_token)
    mail to: user_email.email, subject: I18n.t('account.activate_other_email.subject')
  end

  def account_updated(user_email)
    @profile = user_email.try(:user).try(:profile)
    mail to: user_email.email, subject: I18n.t('account.account_updated.subject')
  end

  def personal_email(user)
     inquiries_count = Inquiry.where(submitter: user).count
     @question_text = (inquiries_count > 1 ? "#{inquiries_count} questions" : "#{inquiries_count} question")
    if inquiries_count > 0
      mail to: user.email, subject: I18n.t('personal_email.subject') do |format|
        format.html { render layout: nil }
      end
    end 
  end

  def inactive_users(user)
     inquiries_count = Inquiry.where(submitter: user).count
    if inquiries_count > 0
      mail to: user.email, subject: I18n.t('personal_email.subject') do |format|
        format.html { render layout: nil }
      end
    end 
  end
end
