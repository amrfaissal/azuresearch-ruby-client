require 'azure_search/utils'

module AzureSearch

  # Represents search options that will be sent along with a search request.
  class IndexSearchOptions
    SPECIAL_PARAMS = %w(count filter orderby select top skip).freeze

    # Specifies whether to fetch the total count of results.
    #
    # @param [TrueClass,FalseClass] val true or false.
    # @return [self] the current instance.
    def include_count(val)
      raise "include_count requires a boolean value." unless is_bool?(val)
      @count = val
      self
    end

    # Sets the structured search expression in standard OData syntax.
    #
    # @param [String] val The filter expression.
    # @return [self] The current instance.
    def filter(val)
      raise "filter requires a String." unless val.is_a? String
      @filter = val
      self
    end

    # Sets the list of comma-separated expressions to sort the results by.
    #
    # @param [String] val Comma-separated expressions.
    # @return [self] The current instance.
    def order_by(val)
      raise "order_by requires a String." unless val.is_a? String
      @orderby = val
      self
    end

    # Sets the list of comma-separated fields to retrieve.
    #
    # @param [String] val Comma-separated fields.
    # @return [self] The current instance.
    def select(val)
      raise "select requires a String." unless val.is_a? String
      @select = val
      self
    end

    # Sets the list of comma-separated field names to search for the specified text.
    #
    # @param [String] val Comma-separated field names.
    # @return [self] The current instance.
    def search_fields(val)
      raise "search_fields requires a String." unless val.is_a? String
      @searchFields = val
      self
    end

    # Sets the list of fields to facet by.
    #
    # @param [Array] fs The list of fields.
    # @return [self] The current instance.
    def facets(fs)
      raise "facts requires an Array of Strings." unless fs.is_a? Array
      @facet = fs
      self
    end

    # Sets the set of comma-separated field names used for hit highlights.
    #
    # @param [String] hl Comma-separated field names.
    # @return [self] The current instance.
    def highlight(hl)
      raise "highlight requires a String." unless hl.is_a? String
      @highlight = hl
      self
    end

    # Sets the string tag that appends to hit highlights (defaults to <em>).
    #
    # @param [String] hpt The string tag.
    # @return [self] The current instance.
    def highlight_pre_tag(hpt)
      raise "highlight_pre_tag requires an HTML string." unless has_html?(hpt)
      @highlightPreTag = hpt
      self
    end

    # Sets the string tag that appends to hit highlights (defaults to </em>).
    #
    # @param [String] hpt The string tag.
    # @return [self] The current instance.
    def highlight_post_tag(hpt)
      raise "highlight_post_tag requires an HTML string." unless has_html?(hpt)
      @highlightPostTag = hpt
      self
    end

    # Sets the name of a scoring profile to evaluate match scores for matching documents.
    #
    # @param [String] sp The scoring profile name.
    # @return [self] The current instance.
    def scoring_profile(sp)
      raise "scoring_profile requires a String." unless sp.is_a? String
      @scoringProfile = sp
      self
    end

    # Sets the values for each parameter defined in a scoring function.
    #
    # @param [Array] params The parameters values.
    # @return [self] The current instance.
    def scoring_parameters(params)
      raise "scoring_parameters requires an Array of Strings." unless params.is_a? Array
      @scoringParameter = params
      self
    end

    # Sets the number of search results to retrieve (defaults to 50).
    #
    # @param [Integer] val The number of search results.
    # @return [self] The current instance.
    def top(val)
      raise "top requires an Integer." unless val.is_a? Integer
      @top = val
      self
    end

    # Sets the number of search results to skip.
    #
    # @param [Integer] val The number to skip (cannot be greater than 100,000).
    # @return [self] The current instance.
    def skip(val)
      raise "skip requires an Integer." unless val.is_a? Integer
      @skip = val
      self
    end

    # Specifies whether any or all of the search terms must be matched.
    #
    # @param [String] mode The search mode.
    # @return [self] The current instance.
    def search_mode(mode)
      raise "invalid search mode." unless ["any", "all"].include? mode
      @searchMode = mode
      self
    end

    # Sets the percentage of the index that must be covered by a search query.
    #
    # @param [Float] val The percentage (must be between 0 and 100).
    # @return [self] The current instance.
    def minimum_coverage(val)
      raise "minimum_coverage requires a Float." unless val.is_a? Float
      raise "minimum_coverage must be between 0 and 100" unless val.between?(0, 100)
      @minimumCoverage = val
      self
    end

    # Returns the search options as a Hash.
    #
    # @return [Hash] The search options as a Hash.
    def to_hash
      hash = {}
      instance_variables.each {|var|
        varname = var.to_s.delete("@")
        if SPECIAL_PARAMS.include? varname
          hash["$"+varname] = instance_variable_get(var)
        else
          hash[varname] = instance_variable_get(var)
        end
      }
      hash
    end
  end

end
