module Fda
  class DrugNameSearch
    BASE_URL = 'http://www.accessdata.fda.gov/scripts/cder/drugsatfda/'

    attr_reader :more_results_url

    def initialize(name)
      @name = name
      @more_results_url = BASE_URL + "index.cfm?fuseaction=Search.SearchAction&SearchType=BasicSearch&searchTerm=#{URI.encode_www_form_component(name)}"
    end

    def drug_info(force = false)
      if force
        fetch_drug_info
      else
        @drug_info || fetch_drug_info
      end
    end

    private 

    def fetch_drug_info
      agent = Mechanize.new
      agent.get(@more_results_url)
      @drug_info = parse(agent.page)
    end

    def parse_overview_page(page)
      # a list of a few products under the same drug name
      first_product_link, *remaining_product_links = *page.links_with(href: /Set_Current_Drug/).reject { |link| link.uri.to_s.include? 'Search.Label_ApprovalHistory' }
      first_product_info = parse_details_page(first_product_link.click, make_absolute(first_product_link.uri))
      [first_product_info] + links_to_hashes(remaining_product_links)
    end

    def parse_details_page(page, uri = @more_results_url)
      # a single drug product
      title = @drug_name
      basic_info = page.search('.details_table').xpath('..').map do |tr| 
        tds = tr.css('td')
        label = strip_whitespace(tds[0].content)
        value =  strip_whitespace(tds[1].content)
        title = value if label == 'Drug Name(s)'
        { label: label, value: value }
      end
      { basic_info: basic_info, url: uri.to_s, title: title }
    end

    def parse_search_results_page(page, uri: @more_results_url)
      # a bunch of different drug names
      links_to_hashes(page.links_with(href: /Search.Overview/))
    end

    def parse(page)
      query = page.try(:uri).try(:query)
      fuseaction = query ? CGI.parse(query)['fuseaction'][0] : ''
      case fuseaction
      when 'Search.Overview'
        parse_overview_page(page)
      when 'Search.DrugDetails'
        [parse_details_page(page)]
      when 'Search.SearchAction' 
        parse_search_results_page(page)
      else
        []
      end
    end

    def strip_whitespace(string)
      string.strip.gsub(/\s+/, ' ')
    end

    def make_absolute(uri)
      URI.join(BASE_URL, uri)
    end

    def links_to_hashes(links) # sounds delicious
      links.map { |link| { title: strip_whitespace(link.text), url: make_absolute(link.uri).to_s } }
    end
  end
end
