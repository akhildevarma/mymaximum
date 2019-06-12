module ApiHelpers
  module TeamHelper

  	def team_by_path
  		unless @team = Team.where("lower(signup_url_path) = ?", params[:signup_url_path].downcase).first
        render_exceptions({id: params[:signup_url_path], type: 'RecordNotFound'}, 404)
      end
  	end

  	def team
  		@team = Team.find_by_id params[:id]
  	end

  	def validate_email
  		if ValidatesEmailFormatOf::validate_email_format(email).present?
        message(:email_invalid, "#{ email } doesn't appear to be a valid email.")
  		end
  	end

  	def email
  		params[:email] || declared( params )["user"]["email"]
  	end

  	def domain
  		email.to_s.downcase.match(/\@(.+)/)[1] if email.present? && email.include?('@')
  	end

  	def validate_domain
      if (@team && domain && @team.email_domain!= domain)
        message(
          :invalid_team_email_domain,
          "Invalid team email domain: #{ domain }. Email domain must match team domain: #{ @team.email_domain }."
        )
      end
  	end

    def validate_all
      team_by_path
      validate_email_format
      validate_domain_format
      validate_existing_user
      if @errors.present?
        error!(error_presenter(@errors), 400)
      end
    end

    def validate_email_format
      if ValidatesEmailFormatOf::validate_email_format(email).present?
        validation_error(
          source: "/data/attributes/email",
          title: "Email #{I18n.t('users.errors.email_format')}",
          detail: "Provided email #{email} #{I18n.t('users.errors.email_format')}",
          code: :invalid_email_format,
          status: :bad_request,
          meta: {
            error_type: 'validation_error',
            validation_error_code: :invalid_email_format,
            validation_error_message: "Provided email #{email} #{I18n.t('users.errors.email_format')}"
          }
        )
      end
    end

    def validate_domain_format
      if (@team && domain && @team.email_domain!= domain)
        validation_error(
          source: "/data/attributes/email_domain",
          title: "Invalid team email domain",
          detail: "Provided email domain #{domain} is not available for this team.",
          code: :invalid_email_domain,
          status: :bad_request,
           meta: {
             error_type: 'validation_error',
             validation_error_code: :invalid_email_domain,
             validation_error_message: "Provided email domain #{domain} is not available for this team."
          }
        )
      end
    end

    def validate_existing_user   
      if User.activated_user(email).last.present?
        validation_error(
          source: "/data/attributes/email",
          title: "User already present in the system",
          detail: "User with email #{ email } already exists. Please login or reset password.",
          code: :user_already_exist,
          status: :bad_request,
          meta: {
             error_type: 'validation_error',
             validation_error_code: :user_already_exist,
             validation_error_message: "User with email #{ email } already exists. Please login or reset password."
          }
        )
      end
    end

    def process_modal_errors(resource)
      errors = resource.errors
      validated_fields = [:password, :password_confirmation, :email]
      validation_errors = []
      validated_fields.each do |f|
        errors[f].map { |e|
          validation_error(
            source: "/data/attributes/#{f.to_s}",
            title: errors.full_message(f, e),
            detail: errors.full_message(f, e),
            code: "#{f}_#{e.split(' ').join('_')}",
            status: :bad_request,
            meta: {
              error_type: 'validation_error',
              validation_error_code: "#{f}_#{e.split(' ').join('_')}",
              validation_error_message: errors.full_message(f, e)
            }
          )
        }
      end
      if @errors.present?
        error!(error_presenter(@errors), 400)
      end

    end

  	def email_taken
  		if User.where({email: email}).exists?
        message(
          :user_exists,
          "User with email #{ email } already exists. Please login or reset password."
        )
  		end
  	end

  end
end
