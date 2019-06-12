module V2
  class MMECalculator < Grape::API
    helpers ApiHelpers::InquiryHelper
    before do
      error!("Unauthorized", 401) unless authenticated
    end

    namespace :mme_calculator do
      desc 'gets all opiods'
      get '/opioids'  do
        present OPIOIDS
      end

      desc 'calculating total daily dose of opioids for safer dosage'
        params do
          requires :total_daily_amount, type: Float, desc: 'Please enter the total daily amount
 of each opioid the patient takes.'
          requires :opioid_value, type: Float, desc: 'OPIOID value from selected dropdown'
        end
        get '/calculate'  do
          opioid =  params[:opioid_value]
          total_daily_amount =  params[:total_daily_amount]
          total_daily_dosage = total_daily_amount + (total_daily_amount * opioid);
          present total_daily_dosage: total_daily_dosage
        end
    end
  end
end
