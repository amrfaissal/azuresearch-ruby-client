require 'azure_search/errors'
require 'http'

module AzureSearch
  API_VERSION = "2016-09-01"

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
    def index_exists
      resp = create_request().get(build_definition_url())
      if resp.code == 404
        return false
      end
      raise_on_http_error(resp)
      return true
    end

    def build_definition_url
      return "https://#{self.service_name}.search.windows.net/indexes/#{self.index_name}?api-version=#{API_VERSION}"
    end

    def create_request
      HTTP.headers({
        "Content-Type": "application/json",
        "api-key": self.api_key
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

    private :build_definition_url, :create_request, :raise_on_http_error
  end
end
