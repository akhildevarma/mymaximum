  module V2
  	class Inquiries < Grape::API
      helpers ApiHelpers::InquiryHelper

      before do
      	error!("Unauthorized", 401) unless authenticated
    	end

      desc 'gets all public inquiries'
      get '/inquiries/public'  do
        inquiries = Inquiry.public_inquiries.reverse_chronological_order
                 .decorate
        Rails.logger.info "Inquiry::count::#{inquiries.count}"
        presenter(inquiries, V2::InquirySerializer, {}, adapter: :json_api)
      end

      desc 'gets team specific inquiries'
      get '/inquiries/team'  do
        inquiries = Inquiry.all_list(current_user).reverse_chronological_order
                 .decorate
        Rails.logger.info "Inquiry::count::#{inquiries.count}"
        presenter(inquiries, V2::InquirySerializer, {}, adapter: :json_api)
      end

    	desc 'gets specific inquiry'
      params do
        requires :id, type: Integer, desc: 'Inquiry ID'
      end
    	get '/inquiries/:id'  do
        resource(Inquiry)
        authorize_resource! unless @resource.view_everyone
        if @errors
          error!( error_presenter( @errors ), 403 )
        else
          @resource.set_read_at!
    	    presenter(@resource.decorate, V2::InquirySerializer, {}, adapter: :json_api)
        end
    	end


      desc 'gets P&T options'
      get '/inquiries/pt/options'  do
        project_types = Inquiry.project_types.options.try(:to_h).try(:invert)
        present data: { attribute_name: 'project_types', options: project_types }, jsonapi: { version: ActiveModelSerializers.config.jsonapi_version }
      end


      desc 're-open specific inquiry'
      params do
        requires :id, type: Integer, desc: 'Inquiry ID'
      end
      get '/inquiries/reopen/:id' do
        resource(Inquiry)
        authorize_resource!
        validate_completed_inquiry
        if @errors
          error!( error_presenter( @errors ), 403 )
        else
          reopen_params = { status: :response_formulation, reopened_at: DateTime.now.utc, turnaround_time: :not_urgent,
                           hidden_sections: { summary_tables: false }
          }
          @resource.update_attributes(reopen_params)
          presenter(@resource.decorate, V2::InquirySerializer, {}, adapter: :json_api)
        end
      end

    	desc 'gets all inquiries'
    	get '/inquiries' do
        inquiries = current_user.submitted_inquiries
                 .reverse_chronological_order
                 .decorate
        inquiries.map(&:mark_response_received!)
        Rails.logger.info "Inquiry::count::#{inquiries.count}"
    	  presenter(inquiries, V2::InquirySerializer, {}, adapter: :json_api)
    	end
  	end
  end
