class CustomAdmin::MailchimpController < CustomAdmin::ApplicationController
  before_filter :authenticate_admin

  def index
    @campaigns = Mailchimp.retrieve_campaigns
  end

  def send_campaign
    response = Mailchimp.send_campaign(params[:campaign_id])
    flash[:notice] = response.try(:body) || response[:body]
    redirect_to custom_admin_mailchimp_index_path
  end
end
