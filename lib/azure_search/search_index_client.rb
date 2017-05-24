require 'azure_search/index_search_options'
require 'azure_search/errors'
require 'azure_search/utils'
require 'http'

# Core module common across the entire API.
#
# @author Faissal Elamraoui
# @since 0.1.0
module AzureSearch
  API_VERSION = "2016-09-01".freeze

  # Client to perform requests to an Azure Search service.
  class SearchIndexClient
    include AzureSearch::Errors

    # @return [Symbol] The search service name.
    attr_accessor :service_name
    # @return [Symbol] The index name.
    attr_accessor :index_name
    # @return [Symbol] The API key generated for the provisioned Search service.
    attr_accessor :api_key

    def initialize(service_name, index_name, api_key)
      if service_name.empty? || index_name.empty? || api_key.empty?
        raise StandardError, "Must provide service_name, index_name and api_key when creating client."
      end

      self.service_name = service_name
      self.index_name = index_name
      self.api_key = api_key
    end

    # Checks if the specified index exists.
    #
    # @return [TrueClass,FalseClass] true if the index exists, false otherwise.
    def exists
      resp = create_request().get(build_index_definition_url())
      if resp.code == 404
        return false
      end
      raise_on_http_error(resp)
      return true
    end

    # Creates the index based on the provided index definition.
    #
    # @param [Hash] definition The index definition.
    # @option definition [String] :name The index name.
    # @option definition [Array<IndexField>] :fields Array of fields.
    # @option definition [Array] :suggesters Array of suggesters.
    def create(definition)
      raise "Index definition must be a Hash." unless definition.is_a? Hash
      definition[:name] = self.index_name unless !definition[:name]
      resp = create_request().post(build_index_list_url(), :json => definition)
      raise_on_http_error(resp)
      return JSON.parse(resp.to_s)
    end

    # Creates or updates the index based on the provided index definition.
    #
    # @param [Hash] definition The index definition.
    # @option definition [String] :name The index name.
    # @option definition [Array<IndexField>] :fields Array of fields.
    # @option definition [Array] :suggesters Array of suggesters.
    def create_or_update(definition)
      raise "Index definition must be a Hash." unless definition.is_a? Hash
      definition[:name] = self.index_name unless definition[:name]
      resp = create_request().put(build_index_definition_url(), :json => definition)
      raise_on_http_error(resp)
      return resp.to_s.empty? ? nil : JSON.parse(resp.to_s)
    end

    # Deletes the specified index.
    #
    # @return [TrueClass,FalseClass] true if the index is deleted, false otherwise.
    def delete
      resp = create_request().delete(build_index_definition_url())
      if resp.code == 404
        return false
      end
      raise_on_http_error(resp)
      return true
    end

    # Inserts documents in batch.
    #
    # @param [Array<IndexBatchOperation>] operations Array of upload operations.
    # @param [Integer] chunk_size The batch size. Must not exceed 1000 documents.
    def batch_insert(operations, chunk_size=1000)
      raise "Batch request must not exceed 1000 documents." unless chunk_size <= 1000
      operations.each_slice(chunk_size)
               .to_a
               .each{|op|
                 resp = create_request().post(build_indexing_url(), :json => {:value => op})
                 raise_on_http_error(resp)
                 resp.to_s
               }
    end

    # Search the index for the supplied text.
    #
    # @param [String] text The text to search for.
    # @param [IndexSearchOptions] options Options to configure the search request.
    #
    # @return [Hash] Parsed JSON response.
    def search(text, options)
      resp = create_request().get(build_index_search_url(text, options))
      raise_on_http_error(resp)
      return JSON.parse(resp.to_s)
    end

    # Lookup an indexed document by key.
    #
    # @param [String] key The key.
    # @return [Hash] The document identified by the supplied key.
    def lookup(key)
      resp = create_request().get(build_index_lookup_url(key))
      raise_on_http_error(resp)
      doc = JSON.parse(resp.to_s)
      doc.delete("@odata.context")
      return doc
    end

    private
    def build_index_definition_url
      "https://#{self.service_name}.search.windows.net/indexes/#{self.index_name}?api-version=#{API_VERSION}"
    end

    def build_index_list_url
      "https://#{self.service_name}.search.windows.net/indexes?api-version=#{API_VERSION}"
    end

    def build_indexing_url
      "https://#{self.service_name}.search.windows.net/indexes/#{self.index_name}/docs/index?api-version=#{API_VERSION}"
    end

    def build_index_search_url(text, options)
      query = {"search" => URI.encode_www_form_component(text)}.merge(options.to_hash)
      "https://#{self.service_name}.search.windows.net/indexes/#{self.index_name}/docs?api-version=#{API_VERSION}&" << to_query_string(query)
    end

    def build_index_lookup_url(key)
      "https://#{self.service_name}.search.windows.net/indexes/#{self.index_name}/docs('#{key}')?api-version=#{API_VERSION}"
    end

    def create_request
      HTTP.headers({
        "Content-Type" => "application/json",
        "api-key" => self.api_key
      })
    end

    def raise_on_http_error(response)
      status_code = response.code
      if status_code > 399
        # 503 means the server is asking for backoff + retry
        if status_code == 503
          raise RetriableHttpError.new(status_code, response.to_s)
        else
          raise StandardError, "#{response.to_s}"
        end
      end
    end

    def validate_search_option(options)
    end
  end
end
