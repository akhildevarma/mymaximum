  module V2
    class DrugShortage < Grape::API
      helpers ApiHelpers::InquiryHelper
      before do
        error!("Unauthorized", 401) unless authenticated
      end

      namespace :drug_shortage_update do
        desc 'gets all fda drug shortages'
        params do
          optional :page, type: Integer, desc: 'Page number - default 1'
          optional :per_page, type: Integer, desc: 'Per Page number - default 10'
        end
        get '/fda_drug_shortages'  do
          page =  (params[:page] || 1)
          per_page =  (params[:per_page] || 10)
          drugs = FdaDrugShortage.all.paginate(page: page, per_page: per_page).order(published_date: :desc)
          presenter(drugs, V2::FdaDrugShortageSerializer, {}, adapter: :json_api)
        end


        desc 'gets all hospital drugs'
        params do
          optional :page, type: Integer, desc: 'Page number - default 1'
          optional :per_page, type: Integer, desc: 'Per Page number - default 10'
        end
        get '/hospital_drugs'  do
          page =  (params[:page] || 1)
          per_page =  (params[:per_page] || 10)
          drugs = HospitalDrug.all.paginate(page: page, per_page: per_page).order(created_at: :desc)
          presenter(drugs, V2::HospitalDrugSerializer, {}, adapter: :json_api)
        end

        desc 'gets all hospital shortages'
        get '/hospital_shortages'  do
          page =  (params[:page] || 1)

          shortages =  {}
          FdaDrugShortage.all.order(:title).each do |drug|
            word = drug.title.split(' ')[0].downcase
            if mached = HospitalDrug.where(["title LIKE :word", {word: "#{word}%"}])
              shortages[word] = drug if !mached.blank?
            end
          end
          presenter(shortages.values, V2::FdaDrugShortageSerializer, {}, adapter: :json_api)
        end
      end
    end
  end
