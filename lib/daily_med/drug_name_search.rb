module DailyMed
  class DrugNameSearch
    include HTTParty

    base_uri 'http://dailymed.nlm.nih.gov/dailymed/services/v1'

    attr_reader :more_results_url

    def initialize(drug_name)
      @drug_name = drug_name
      @more_results_url = "http://dailymed.nlm.nih.gov/dailymed/search.cfm?labeltype=all&query=#{drug_name}"
    end

    def spls(force: false)
      force ? fetch_spls : @spls || fetch_spls
    end

    private

    def fetch_spls
      response = begin
        self.class.get("/drugname/#{URI.encode_www_form_component(@drug_name)}/spls.xml", follow_redirects: true)
      rescue HTTParty::RedirectionTooDeep
        nil
      end
      unless response && response.content_type == 'application/xml'  # response code when no results are found
        return @spls = []
      end
      response_doc = Nokogiri::XML.parse(response.body)
      spl_nodes = response_doc.css('spl')
      @spls = spl_nodes.map { |spl_node| convert_to_hash(spl_node) }.sort { |x, y| y[:published_date] <=> x[:published_date] } # descending
    end

    def convert_to_hash(spl_node)
      setid = spl_node.css('setid').text
      {
        setid: setid,
        spl_version: spl_node.css('spl_version').text,
        published_date: spl_node.css('published_date').text.to_date,
        title: spl_node.css('title').text,
        url: "http://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=#{setid}"
      }
    end
  end
end
