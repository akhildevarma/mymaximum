
object @topic_search
attributes :id, :errors
node(:medline_plus_result_url) {
  topic_search_medline_plus_result_url(self, format: :json)
}

node(:guideline_gov_result_url) {
  topic_search_guideline_gov_result_url(self, format: :json)
}

node(:daily_med_result_url) {
  topic_search_daily_med_result_url(self, format: :json)
}

node(:fda_result_url) {
  topic_search_fda_result_url(self, format: :json)
}
