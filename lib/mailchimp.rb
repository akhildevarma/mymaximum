class Mailchimp
  
  # options hash includes
  # count -  no of results
  # status - save by default
  # sort_field - create_time - default
  # sort_dir - DESC
  def self.retrieve_campaigns(options = {})

    options = {
      count: '10',
      status: 'save',
      sort_field: 'create_time',
      sort_dir: 'DESC'
    } if options.blank?

    campaigns = self.gibbon.campaigns.retrieve(params: options)
    if campaigns && campaigns.body.present?
      campaigns.body[:campaigns].inject([]) do |result, item|
        if item[:recipients] && item[:recipients][:list_id].present?
          result << { campaign_id: item[:id], subject_line: item[:settings][:subject_line], title: item[:settings][:title]}
        else
          result
        end
      end
    end
  end


  def self.gibbon
    @gibbon ||= Gibbon::Request.new
  end

  def self.send_campaign(campaign_id)
    response = self.gibbon.campaigns(campaign_id).actions.send.create
    response ||= { body: 'Successfully sent this campaign'}
    response
  end

end
