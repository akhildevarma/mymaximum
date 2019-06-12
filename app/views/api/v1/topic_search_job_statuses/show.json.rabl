object @job_statuses => nil

node(:complete) { |js| js[:complete] }

node(:medline_plus_query_complete) { |js| js[:medline_plus_query_complete] }
node(:medline_plus_result) { |js| js[:medline_plus_result] }

node(:guideline_gov_query_complete) { |js| js[:guideline_gov_query_complete] }
node(:guideline_gov_result) { |js| js[:guideline_gov_result] }

node(:daily_med_query_complete) { |js| js[:daily_med_query_complete] }
node(:daily_med_result) { |js| js[:daily_med_result] }

node(:fda_query_complete) { |js| js[:fda_query_complete] }
node(:fda_result) { |js| js[:fda_result] }
