desc "Update DailyMed more results for existing searchs to new url"
task :update_daily_med_more_results => :environment do
  topic_searches = TopicSearch.where("drug_name is not null and daily_med_result is not null")
  topic_searches.each do |ts|
    if !ts.daily_med_result.blank? && !ts.drug_name.blank?
      puts " Existing more results url:: #{ts.daily_med_result['more_results_url']}"
      ts.daily_med_result['more_results_url'] = "http://dailymed.nlm.nih.gov/dailymed/search.cfm?labeltype=all&query=#{ts.drug_name}"
      ts.save
      puts " Updated more results url:: #{ts.daily_med_result['more_results_url']}"
    end
  end
end
