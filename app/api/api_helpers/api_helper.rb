module ApiHelpers
  module ApiHelper

    def access_token
      params[:access_token] ||= request.headers['X-Access-Token']
    end

		def current_user
    	@api_key = APIKey.where(access_token: access_token).first
      if @api_key && !@api_key.expired?
        @current_user = @api_key.user
      else
        false
      end
    end

    def current_user=(user)
      @current_user = user
    end

    def authenticated
      return true if current_user
      if @api_key && @api_key.expired?
      	render_exception("Access token is expired: #{@api_key.access_token}.Please login again to get a new token", 401)
      elsif @current_user.nil?
      	render_exception("Must provide an authenticated user to use the api", 401)
      end
    end

    def resource(resource_type)
    	@resource = resource_type.find_by_id(params[:id])
      error!( error_presenter( JSONAPI::Exceptions::RecordNotFound.new(params[:id]).errors ), 404 ) unless @resource
    end

    def authorize_resource!
    	add_error(
        JSONAPI::Error.new(
          code: JSONAPI::FORBIDDEN,
          status: :forbidden,
          title: I18n.t('jsonapi-resources.exceptions.forbidden_resource.title',
                        default: 'Forbidden resource'),
          detail: I18n.t('jsonapi-resources.exceptions.forbidden_resource.detail',
                         default: "Access to #{@resource} is forbidden.")
         )
       ) unless current_user.can_update?(@resource)
    end

    def presenter(resource, serializer, options={}, adapter: :json_api)
			if resource.respond_to?(:each)
				resource_collection = ActiveModel::Serializer::CollectionSerializer.new(resource, serializer: serializer)
			else
				resource_collection = serializer.new(resource)
			end
			json_array =ActiveModelSerializers::Adapter.adapter_class(adapter).new(resource_collection, options)
			present json_array
		end

    def render_exception(message, status)
      error!(message, status)
    end

    def render_exceptions(options={}, status=500)
      exception_class = "JSONAPI::Exceptions::#{options[:type]}".constantize
      status 400
      error!(error_presenter(exception_class.new(options[:id]).errors), status)
    end

	  def add_error(error)
      @errors ||= []
      @errors << error
	  end

    def validation_error(options)
      add_error(
        JSONAPI::Error.new(
          options
        )
      )
    end

	  def message(code, message)
	  	@message ||= OpenStruct.new(code: code.to_s, message: message)
    end

    def error_presenter(errors)
      error_hash = { errors: [] }
      errors.each { |error|
        error.code = :record_not_found if error.try(:code)==404
        error_hash[:errors] << error
      }
      error_hash[:jsonapi] = { version: ActiveModelSerializers.config.jsonapi_version }
      error_hash
    end
	end
end
