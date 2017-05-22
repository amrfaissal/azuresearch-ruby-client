require 'nokogiri'

module AzureSearch

  # Checks if the supplied value is a Boolean.
  #
  # @param [Object] value The value to check.
  # @return [TrueClass,FalseClass] true or false.
  def is_bool?(value); [true, false].include? value end

  # Checks if the supplied text contains valid HTML.
  #
  # @param [String] text The text to check.
  # @return [TrueClass,FalseClass] true or false.
  def has_html?(text); Nokogiri::XML(text).errors.empty? end

  # Converts a Hash into query parameters string.
  #
  # @param [Hash] params The hash to convert.
  # @return [String] query string.
  def to_query_string(params)
    params.map{|k,v|
      if v.nil?
        k.to_s
      elsif v.respond_to?(:to_ary)
        v.to_ary.map{|w|
          str = k.to_s.dup
          unless w.nil?
            str << '='
            str << w.to_s
          end
        }.join('&')
      else
        str = k.to_s.dup
        str << '='
        str << v.to_s
      end
    }.join('&')
  end

end
