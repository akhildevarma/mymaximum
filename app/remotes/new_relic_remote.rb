class NewRelicRemote
  def self.report(e, params = {})
    if Rails.env.test? || Rails.env.development?
      Rails.logger.info 'Development Mode: Cannot send to NewRelic'
    else
      if !!params && params.length > 0
       ::NewRelic::Agent.notice_error(e, params)
      else
       ::NewRelic::Agent.notice_error(e)
      end
    end
  end
end
