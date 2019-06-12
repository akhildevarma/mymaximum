module GuidelineGov
  class Search
    include HTTParty

    base_uri 'http://www.guideline.gov/search/search.aspx'
    default_params type: 'external'

    attr_reader :more_results_url

    def initialize(search_term)
      @search_term = search_term
    end

    def first_result(force: false)
      force ? fetch_result : @result || fetch_result
    end

    private

    def fetch_result
      @result = scrape_from(self.class.get('', query: { term: @search_term }))
    end

    def scrape_from(response)
      @more_results_url = response.request.uri.to_s
      doc = Nokogiri::HTML(response)
      result_anchors = doc.css(".results-list-item-title a")
      if result_anchors.size > 0
        guideline = GuidelineSummary.new(result_anchors[0]['href'])
        guideline
      end
    end

  end
end
