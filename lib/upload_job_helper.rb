module UploadJobHelper
  class << self
    def process_data(bulk_user)
      @bulk_user = bulk_user
      set_params
      save_all
      add_error_messages
    end

    def save_all
      @user  = process_user
      if @user.valid? && @user.save!
        @profile = profile 
        @profile.user = @user
        if @profile.valid? && @profile.save!
          @bulk_user.status = UploadUser::COMPLETED
          save_provider
          update_user_details
          send_notification
        elsif @profile.errors.any?
          @user.destroy!
        end  
      end
    end

    def save_provider
      @provider = provider
      @provider.user = @user
      @provider.save(validate: false)
    end

    def update_user_details
      @user.update_attribute(:last_active_at, Time.now)
    end

    def add_error_messages
      errors = []
      errors << @user.errors if @user && @user.errors.any?
      errors << @profile.errors if @profile && @profile.errors.any?
      errors = errors.compact
      if errors.present?
        @bulk_user.message = errors.map(&:full_messages).flatten!.join(",")
        @bulk_user.status = UploadUser::ERROR
        send_duplicate_notification
      end
      @user  = process_user
    end

    def set_params
      @user_params = {
        email: @bulk_user.email,
        team_id: @bulk_user.team_id
      }

      @provider_params = {
        specialty: @bulk_user.specialty
      }

      @profile_params = @bulk_user.slice(:first_name, :last_name, :phone_number)
    end

    def process_user
      User.new(add_user_params)
    end

    def provider
      Provider.new(@provider_params)
    end

    def profile
      Profile.new(@profile_params)
    end

    def add_user_params
      set_password_params
    end

    def send_notification
       Notification.create(user: @user,notification_type: Notification::ADD_TEAM_USER, sent_at: Time.now, referenceable:@user, sent_via: Notification::EMAIL)
    end

    def send_duplicate_notification
      if @user.email && (@user_notification = User.where(email: @user.email.downcase).first)
        AccountActivationMailer.add_team_activation(@user_notification).deliver_later
      end
    end

    def set_password_params
      password = SecureRandom.urlsafe_base64(6, false)
      @user_params[:password] = password
      @user_params[:password_confirmation] = password
      @user_params
    end
  end
end
