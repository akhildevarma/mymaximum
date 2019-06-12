class CustomAdmin::DrugShortageController < CustomAdmin::ApplicationController
  before_filter :require_user
  skip_before_filter :authenticate_admin


  def index
    params[:active_tab] ||= 'shortage-tab'
    @drugs = FdaDrugShortage.search(params[:fda_search]).paginate(page: params[:fda_page], per_page: 10).order(published_date: :desc)
    @hospital_drugs = HospitalDrug.search(params[:search],current_user.team_id).paginate(page: params[:hospital_page], per_page: 10)
    shortages

  end

  def reload
    xml_param = (params[:xml_param] || 'UCM163172')
    FdaDrugShortage.reload(xml_param)
    redirect_to drug_shortages_path
  end

  def upload
    total_rows = HospitalDrug.process_file(parsed_file,params[:hospital_drug][:team_id])
    redirect_to drug_shortages_path
  end

  private

    def parsed_file
      SpreadsheetParser.open_spreadsheet(params[:hospital_drug][:file])
    end

    def shortages
      @shortages =  {}
      FdaDrugShortage.all.order(:title).each do |drug|
        word = drug.title.split(' ')[0].downcase
        if mached = HospitalDrug.where(["title LIKE :word", {word: "#{word}%"}])
          @shortages[word] = drug if !mached.blank?
        end
      end
    end

end
