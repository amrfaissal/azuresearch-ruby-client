module AzureSearch

  # Defines errors that are raised by AzureSearch client.
  #
  # @since 0.1.0
  module Errors

    # Raised to indicate that a HTTP request needs to be retried.
    class RetriableHttpError < StandardError
      # @return [Symbol] The response status code.
      attr_accessor :code
      # @return [Symbol] The error message.
      attr_accessor :message

      def initialize(code, message)
        self.code = code
        self.message = message
      end

      def to_s
        "RetriableHttpError <#{self.code}>: #{self.message}"
      end
    end

  end
end
