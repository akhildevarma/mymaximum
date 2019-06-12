class UserProfile
  include JsonErrorResource

  attr_reader :user, :profile, :provider, :is_admin

  json_error_associations :user, :profile, :provider

  def self.for(user)
    new(user)
  end

  def initialize(user)
    @user = user
    @profile = user.profile || Profile.new(user: user)
    @provider = user.provider
  end

  def id
    user.id
  end

  def is_admin
    @user.administrator?
  end

  def has_profile?
    @profile.present? && @profile.persisted?
  end

  def update(params)
    @user.with_transaction_returning_status do
      user_update_status = update_user(params[:user])
      profile_update_status = update_profile(params[:profile])
      emails_update_status = update_emails(params[:user_email])
      provider_update_status = update_provider(params[:provider])
      status = user_update_status && profile_update_status && provider_update_status
    end
  end

  private

  def update_user(params)
    if params.present?
      @user.update(params)
    else
      true
    end
  end

  def update_profile(params)
    if has_profile_changes(params) && params.present?
      params[:phone_number] =  nil if params[:phone_number].blank?
      @profile.update(params)
    else
      true
    end
  end

  def update_emails(params)
    if params.present?
      no_id_params = params.except(:id)
      no_id_params[:user] = user
      if emails = User::Email.find_by(id: params[:id])   
        emails.update(no_id_params)
        UserMailer.account_updated(emails).deliver_now
      else
       User::Email.create(no_id_params)
      end
    else
      true
    end
  end

  def update_provider(params)
    if @provider.present? && params.present?
      @provider.update(params)
    else
      true
    end
  end

  def has_profile_changes(params)
    !params.reject { |_k, v| v.blank? }.empty?
  end
end
