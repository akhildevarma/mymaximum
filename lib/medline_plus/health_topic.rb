module MedlinePlus
  class HealthTopic
    attr_reader :title, :url, :full_summary, :also_calleds, :groups,
                :mesh_headings, :sites, :related_topics

    def self.list_from_query_result(result)
      result_count = result['nlmSearchResult']['count']
      return [] if result_count == '0'
      topics = []
      documents = [result['nlmSearchResult']['list']['document']].flatten
      documents.each do |doc_hash|
        topics << HealthTopic.new(doc_hash['content']['health_topic'])
      end
      topics
    end

    def initialize(topic_hash)
      @title = topic_hash['title']
      @url = topic_hash['url']
      @full_summary = topic_hash['full_summary']
      @also_calleds = [topic_hash['also_called']].flatten.compact
      @groups = [topic_hash['group']].flatten.compact.map { |g| OpenStruct.new(title: g['__content__'], url: g['url']) }
      @mesh_headings =  [topic_hash['mesh_heading']].flatten.compact.map { |m| OpenStruct.new(title: m['descriptor']['__content__'], id: m['descriptor']['id']) }
      @sites = [topic_hash['site']].flatten.compact.map { |s| o = OpenStruct.new(s); o.organization = [o.organization].flatten.compact; o }
      @related_topics = [topic_hash['related_topic']].flatten.compact.map { |r| OpenStruct.new(title: r['__content__'], url: r['url']) }
    end
  end
end
