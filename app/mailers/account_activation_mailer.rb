class AccountActivationMailer < ApplicationMailer

  def account_activation(user)
    @user = user.decorate
    @url = account_activation_url(token: @user.account_activation_token)
    mail(to: @user.email, subject: I18n.t('account.activation.mailer_subject'))
  end

  def add_team_activation(user)
    @user = user.decorate
    @layout = 'application_mailer'
    if @team = user.team
      @team_name = @team.capitalized_name 
      @team_admin_name = @team.team_admin_name
      @layout = 'private_label_mailer' if @team.private_label
    end 
    @url = add_team_user_signups_url(signup_url_path: (@user.team.try :signup_url_path) , token: @user.account_activation_token)
    mail(to: @user.email, subject: I18n.t('account.activation.add_team_subject')) do |format|
      format.html { render layout: @layout }
      format.text
    end
  end

  def second_team_activation(user)
    @user = user.decorate
    @name = @user.name
    if team = user.team
      @team_name = team.capitalized_name 
      @team_admin_name = team.team_admin_name
    end
    @url = add_team_user_signups_url(signup_url_path: (@user.team.try :signup_url_path) , token: @user.account_activation_token)
    @team_admin_name = (@user.team.user || User.find_by(email: @user.team.admin_email)).decorate.try(:name)
    mail(to: @user.email, subject: I18n.t('account.activation.add_team_subject'))
  end

end
