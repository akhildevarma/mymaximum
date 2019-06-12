module ApiHelpers
  module ProviderHelper
    def errors_for(model_instance)
      raise 'Must inherit JsonErrorResource' unless model_instance.is_a? JsonErrorResource
      model_serializer_class_name = "::#{model_instance.class}ErrorSerializer"
      serializer_class = Object.const_defined?(model_serializer_class_name) ? model_serializer_class_name.constantize : ErrorSerializer
      errors = serializer_class.new(model_instance)
      errors = JSON.parse errors.to_json
      process_modal_errors(errors.with_indifferent_access)
    end

    def model_fields
      {
        user: [ :password, :password_confirmation, :email ],
        provider: [ :license_number, :license_state ],
        profile: [ :first_name, :last_name ]
      }.with_indifferent_access
    end

    # {"provider_signup"=>{},
    # "user"=>{"password"=>["too_short"]},
    # "provider"=>{"user_id"=>["cant_be_blank"]},
    # "profile"=>{"user_id"=>["cant_be_blank"]},
    # "payment_account"=>{"user_id"=>["cant_be_blank"]}}
    def process_modal_errors(errors)
      validation_errors = []
      model_fields.each do |f|
        model_obj = f.first
        errors[model_obj].map { |e|
          field = e.first.to_s
          message = e.last.join('_')
          if (field!='user_id')
            validation_error(
              source: "/data/attributes/#{field}",
              title: message,
              detail: message,
              code: "#{field}_#{message}",
              status: :bad_request,
              meta: {
                error_type: 'validation_error',
                validation_error_code: "#{field}_#{message}",
                validation_error_message: message
              }
            )
          end
        }
      end
      if @errors.present?
        error!(error_presenter(@errors), 400)
      end

    end


    def email
      params[:email] || declared( params )["user"]["email"]
    end
    
    def validate_all
      validate_email_format
      validate_existing_user
      if @errors.present?
        error!(error_presenter(@errors), 400)
      end
    end
    
    def validate_existing_user
      if User.where({email: email}).exists?
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

  end
end
