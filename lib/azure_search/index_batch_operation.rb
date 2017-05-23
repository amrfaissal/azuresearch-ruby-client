require 'json'

module AzureSearch

  # Represents a batch operation in an indexing request.
  class IndexBatchOperation
    # Encapsulates the supplied document in an IndexUploadOperation.
    #
    # @param [Hash] document The document.
    # @return [Hash] The upload operation as a Hash.
    def self.upload(document)
      IndexUploadOperation.new(document).to_hash
    end

    # Encapsulates a delete request in an IndexDeleteOperation.
    #
    # @param [String] key_name The key name.
    # @param [String] key_value The key value.
    def self.delete(key_name, key_value)
      IndexDeleteOperation.new(key_name, key_value).to_hash
    end

    # @todo Add support for merge & merge_or_upload
  end

  # Represents an upload operation of a document.
  class IndexUploadOperation < IndexBatchOperation
    def initialize(document)
      @document = document
    end

    # Returns the upload operation as a Hash.
    #
    # @return [Hash] The upload operation.
    def to_hash
      @document["@search.action"] = "upload"
      @document
    end
  end

  # Represents a document deletion request.
  class IndexDeleteOperation < IndexBatchOperation
    def initialize(key_name, key_value)
      @key_name = key_name
      @key_value = key_value
    end

    # Returns the delete operation as a Hash.
    #
    # @return [Hash] The delete operation.
    def to_hash
      {
        @key_name => @key_value,
        "@search_action" => "delete"
      }
    end
  end

end
