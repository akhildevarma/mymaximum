module Fda
  class DrugShortage
    include HTTParty
    base_uri 'http://www.fda.gov/downloads/Drugs/DrugSafety/DrugShortages'

    def initialize(name)
      @name = name
    end

    def load_drug_shortages
      load_items
    end

    private

    def load_items
      response = begin
      self.class.get("/#{@name}.xml")
      rescue HTTParty::RedirectionTooDeep
      nil
    end

    response_doc = Nokogiri::XML.parse(response.body)


    item_nodes = response_doc.css('item')
      if item_nodes.present?
        FdaDrugShortage.delete_all
        items = item_nodes.map {|item| convert_to_hash (item) }
        FdaDrugShortage.create(items)
      end

    end

    def convert_to_hash(item)
      {
      title: item.css('title').text,
      description: item.css('description').text,
      published_date: item.css('pubDate').text,
      link: item.css('link').text.gsub(/amp;|mp;/,'&')
      }
    end
  end
 end
