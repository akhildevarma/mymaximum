module V2
  class Uploaders < Grape::API
    before do
      error!("Unauthorized", 401) unless authenticated
    end

    desc 'Upload files'
    namespace :docs do
      params do      
        requires :user_id, type: Integer, desc: 'Id of the current logged in user'
        requires :file, type: Rack::Multipart::UploadedFile, desc: 'Upload a File - supported types -pdf/doc/xls'
        requires :referenceable_id, type: Integer, desc: 'Referenceable Id like id of inquiry/user etc'
        requires :referenceable_type, type: String, desc: 'Type of the referenceable object like Inquiry/User'      
      end

      post do
        params[:file] = ActionDispatch::Http::UploadedFile.new(params[:file])
        @document = Document.create( declared(params))

        if @document.errors.any?
          error!({ 'error_msg' =>  @document.errors}, 401)     
        else
           presenter(@document, V2::DocumentSerializer)
        end
      end


      desc 'Get all documents to specific inquiry'  
      params do      
        requires :id, type: Integer, desc: 'Inquiry ID'      
      end

      get 'inquiry_docs/:id' do
        resource(Inquiry)
        authorize_resource!
        if @errors
          error!( error_presenter( @errors ), 403 )
        else
          presenter(@resource.documents, V2::DocumentSerializer, {}, adapter: :json_api)
        end
      end

      desc 'Get all documents to specific team'  
      params do      
        requires :id, type: Integer, desc: 'Team ID'      
      end

      get 'team_docs/:id' do
        resource(Team)
        authorize_resource!
        if @errors
          error!( error_presenter( @errors ), 403 )
        else
          presenter(@resource.documents, V2::DocumentSerializer, {}, adapter: :json_api)
        end
      end
    end
  end
end
