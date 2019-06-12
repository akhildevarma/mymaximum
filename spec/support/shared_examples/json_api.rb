RSpec.shared_examples "json_api" do |parameter|

  describe 'json_api' do
    # Shared context
    let(:no_document_required) { [202, 204, 403, 404, 409].include?(response.status) }
    let(:document) { (!no_document_required && response && !response.body.empty?) ? JSON.parse(response.body) : nil }

    #TODO Test various standard requests against endpoint
    # i.e Servers MUST respond with a 415 Unsupported Media Type status code if a request specifies the header Content-Type: application/vnd.api+json with any media type parameters.
    describe "Client Negotiation" do
      describe "Server Responsabilities" do
        it "complies" do
        # Servers MUST send all JSON API data in response documents with the header Content-Type: application/vnd.api+json without any media type parameters.
          expect(response).to have_content_type(JSONAPI::MEDIA_TYPE) unless response.status.in? ActionDispatch::Response::NO_CONTENT_CODES
        #TODO Servers MUST respond with a 415 Unsupported Media Type status code if a request specifies the header Content-Type: application/vnd.api+json with any media type parameters.
        #TODO Servers MUST respond with a 406 Not Acceptable status code if a request's Accept header contains the JSON API media type and all instances of that media type are modified with media type parameters.
        end
      end
    end

    describe "Document Structure" do
      let(:required_keys) { [
        'data',
        'errors',
        'meta'
      ] }
      let(:optional_keys) { [
        'jsonapi',
        'links',
        'included'
      ] }
      let(:keys_whitelist) { required_keys + optional_keys }
      let(:links_pagination_keys) { ['first','last','prev','next'] }
      let(:link_allowed_keys) { ['self','related'] + links_pagination_keys }
      it 'complies' do
        if document
        # A JSON object MUST be at the root of every JSON API request and response containing data.
        # This object defines a document's "top level".
          expect(document).to be_a(Hash)
        # A document MUST contain at least one of the following top-level members:
        # - data: the document's "primary data"
        # - errors: an array of error objects
        # - meta: a meta object that contains non-standard meta-information.
          keys = document.keys - optional_keys
          unless keys
            keys.each { |k| expect(required_keys).to include(k)}
          end
        # A document MAY contain any of these top-level members:
        # - jsonapi: an object describing the server's implementation
        # - links: a links object related to the primary data.
        # - included: an array of resource objects that are related to the primary data and/or each other ("included resources").
          keys = document.keys - required_keys
          if keys.present?
            keys.each { |k| expect(optional_keys).to include(k) }
          end
        # Attempt at JSON Schema for JSON-API response document
          expect(response.body).to match_response_schema 'jsonapi'
        # If a document does not contain a top-level data key, the included member MUST NOT be present either.
          data_key_present = document.keys.include?('data')
          expect(document.keys).not_to include('included') unless data_key_present
        # The top-level links object MAY contain the following members:
        # - self: the link that generated the current response document.
        # - related: a related resource link when the primary data represents a resource relationship.
        # - pagination links for the primary data.
        # The document's "primary data" is a representation of the resource or collection of resources targeted by a request.
          links = document['links']
          if links.present?
            links.keys.each { |k| expect(allowed_keys).to include(k) }
          end
        # Primary data MUST be either:
        # - a single resource object, a single resource identifier object, or null, for requests that target single resources
        # - an array of resource objects, an array of resource identifier objects, or an empty array ([]), for requests that target resource collections
          data = document['data']
          if data
            expect(data).to satisfy { |d| d.is_a?(Array) || d.is_a?(Hash) }
            body = ( data.is_a?(Array) ? data.first : data ).to_json
            expect(body).to match_response_schema 'jsonapi_resource'
          end



        end # If
      end # It

      describe "Compound Document" do
      # To reduce the number of HTTP requests, servers MAY allow responses that include related resources along with the requested primary resources. Such responses are called "compound documents".
      #
      # In a compound document, all included resources MUST be represented as an array of resource objects in a top-level included member.
      #
      # Compound documents require "full linkage", meaning that every included resource MUST be identified by at least one resource identifier object in the same document. These resource identifier objects could either be primary data or represent resource linkage contained within primary or included resources.
      #
      # The only exception to the full linkage requirement is when relationship fields that would otherwise contain linkage data are excluded via sparse fieldsets.
      #
      # A compound document MUST NOT include more than one resource object for each type and id pair.
      end

      describe "Meta" do
      # Where specified, a meta member can be used to include non-standard meta-information. The value of each meta member MUST be an object (a "meta object").
      #
      # Any members MAY be specified within meta objects.
      #NOTE Included in ... match_response_schema 'jsonapi_resource'
      end

      describe "Links" do
      # Where specified, a links member can be used to represent links. The value of each links member MUST be an object (a "links object").
      #
      # Each member of a links object is a "link". A link MUST be represented as either:
      # - a string containing the link's URL.
      # - an object ("link object") which can contain the following members:
      # - href: a string containing the link's URL.
      # - meta: a meta object containing non-standard meta-information about the link.

      #NOTE Included in ... match_response_schema 'jsonapi_resource'
      end

      describe "JSON API object" do
        # A JSON API document MAY include information about its implementation under a top level jsonapi member.
        # If present, the value of the jsonapi member MUST be an object (a "jsonapi object").
        # The jsonapi object MAY contain a version member whose value is a string indicating the highest JSON API version supported.
        # This object MAY also contain a meta member, whose value is a meta object that contains non-standard meta-information.
        #NOTE Included in ... match_response_schema 'jsonapi'
      end

      describe "Member names" do
      # All member names used in a JSON API document MUST be treated as case sensitive by clients and servers, and they MUST meet all of the following conditions:
      #
      # Member names MUST contain at least one character.
      # Member names MUST contain only the allowed characters listed below.
      # Member names MUST start and end with a "globally allowed character", as defined below.
      # To enable an easy mapping of member names to URLs, it is RECOMMENDED that member names use only non-reserved, URL safe characters specified in RFC 3986.
      #
      # == Allowed Characters ==
      #
      # The following "globally allowed characters" MAY be used anywhere in a member name:
      # - U+0061 to U+007A, "a-z"
      # - U+0041 to U+005A, "A-Z"
      # - U+0030 to U+0039, "0-9"
      # - U+0080 and above (non-ASCII Unicode characters; not recommended, not URL safe)
      #
      # Additionally, the following characters are allowed in member names, except as the first or last character:
      # - U+002D HYPHEN-MINUS, "-"
      # - U+005F LOW LINE, "_"
      # - U+0020 SPACE, " " (not recommended, not URL safe)
      # - Reserved Characters
      #
      # The following characters MUST NOT be used in member names:
      # - U+002B PLUS SIGN, "+" (used for ordering)
      # - U+002C COMMA, "," (used as a separator between relationship paths)
      # - U+002E PERIOD, "." (used as a separator within relationship paths)
      # - U+005B LEFT SQUARE BRACKET, "[" (used in sparse fieldsets)
      # - U+005D RIGHT SQUARE BRACKET, "]" (used in sparse fieldsets)
      # - U+0021 EXCLAMATION MARK, "!"
      # - U+0022 QUOTATION MARK, '"'
      # - U+0023 NUMBER SIGN, "# -"
      # - U+0024 DOLLAR SIGN, "$"
      # - U+0025 PERCENT SIGN, "%"
      # - U+0026 AMPERSAND, "&"
      # - U+0027 APOSTROPHE, "'"
      # - U+0028 LEFT PARENTHESIS, "("
      # - U+0029 RIGHT PARENTHESIS, ")"
      # - U+002A ASTERISK, "*"
      # - U+002F SOLIDUS, "/"
      # - U+003A COLON, ":"
      # - U+003B SEMICOLON, ";"
      # - U+003C LESS-THAN SIGN, "<"
      # - U+003D EQUALS SIGN, "="
      # - U+003E GREATER-THAN SIGN, ">"
      # - U+003F QUESTION MARK, "?"
      # - U+0040 COMMERCIAL AT, "@"
      # - U+005C REVERSE SOLIDUS, "\"
      # - U+005E CIRCUMFLEX ACCENT, "^"
      # - U+0060 GRAVE ACCENT, "`"
      # - U+007B LEFT CURLY BRACKET, "{"
      # - U+007C VERTICAL LINE, "|"
      # - U+007D RIGHT CURLY BRACKET, "}"
      # - U+007E TILDE, "~"
      # - U+007F DELETE
      # - U+0000 to U+001F (C0 Controls)
      end
    end # Describe

    describe "Fetching Data" do
      describe "Fetching resources" do
        # A server MUST support fetching resource data for every URL provided as:
        # - a self link as part of the top-level links object
        # - a self link as part of a resource-level links object
        # - a related link as part of a relationship-level links object
        it "complies" do
          if document
            document.extend(Hashie::Extensions::DeepFind)
            top_level = document['links']
            relationships = document.deep_find(:relationships).extend(Hashie::Extensions::DeepFind)
            data = document.deep_find(:data).extend(Hashie::Extensions::DeepFind)
            links = [
              top_level.try(:[], 'self'),
              relationships.deep_select(:self),
              data.deep_select(:related)
            ].compact.reduce(:+)
            test_links(links)
          end # if
        end # it
      end # describe

      describe "Fetching relationships" do

        # A server MUST support fetching relationship data for every relationship URL provided as a self link as part of a relationship's links object.
        it "complies" do
          if document
            data = document['data'].extend(Hashie::Extensions::DeepFind)
            links = data.deep_select(:self)
            test_links(links)
          end
        end # If
      end

      def test_links(links=[])
        return if links.blank?
        #NOTE Expecting bugs with this test.
        print "\nTesting document links"
        puts links
        puts ""
        links.each do |link|
          endpoint = (link.is_a? Enumerable) ? link['href'] : link
          get endpoint, {}, @env
          test_success_of_get_request(response)
        end
      end

      def test_success_of_get(response)
        expect(response.status).to have_http_status 200
        expect(response.body).to match_response_schema 'jsonapi'
      end
    end





    # Test Status
    it 'can create' do
      success_code_matcher = /^(2\d+)/
      success_code = success_code_matcher =~ String(response.status)
      if (@http_request_type == :post) && success_code
        self_link = JSON.parse(response.body)['data']['links'].try(:[], 'self')
        location = response.headers['Location']
        expect(response).to have_http_status 201
        expect(location).to be_present
        expect(self_link).to eq(location) if self_link
      end
    end

    it 'can error' do
      error_code_matcher = /^((1|4|5)\d+)/
      is_error = error_code_matcher =~ String(response.status)
      if is_error && response.body.present?
        body = JSON.parse(response.body)
        expect(body).to have_key('errors')
      end
    end

  end
end
