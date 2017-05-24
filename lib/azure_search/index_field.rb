module AzureSearch

  # Represents an Index field definition.
  class IndexField
    # Valid EDM (Entity Data Model) data types.
    VALID_EDM_TYPES = [
      "Edm.String",
      "Collection(Edm.String)",
      "Edm.Boolean",
      "Edm.Int32",
      "Edm.Int64",
      "Edm.Double",
      "Edm.DateTimeOffset",
      "Edm.GeographyPoint"
    ].freeze

    def initialize(name, type)
      raise "Field name is required." unless !name.empty?
      @name = name
      raise "Invalid field type." unless VALID_EDM_TYPES.include? type
      @type = type
    end

    # Sets the analyzer name used for search and indexing.
    #
    # @param [String] analyzer The analyzer name.
    # @return [self] The current instance.
    def analyzer(analyzer)
      @analyzer = analyzer
      self
    end

    # Sets the field to be searchable.
    #
    # @param [TrueClass,FalseClass] searchable true or false.
    # @return [self] The current instance.
    def searchable(searchable)
      raise "searchable must be a boolean." unless is_bool? searchable
      @searchable = searchable
      self
    end

    # Sets the field to be filterable.
    #
    # @param [TrueClass,FalseClass] filterable true or false.
    # @return [self] The current instance.
    def filterable(filterable)
      raise "filterable must be a boolean." unless is_bool? filterable
      @filterable = filterable
      self
    end

    # Sets the field to be retrievable.
    #
    # @param [TrueClass,FalseClass] retrievable true or false.
    # @return [self] The current instance.
    def retrievable(retrievable)
      raise "retrievable must be a boolean." unless is_bool? retrievable
      @retrievable = retrievable
      self
    end

    # Sets the field to be sortable.
    #
    # @param [TrueClass,FalseClass] sortable true or false.
    # @return [self] The current instance.
    def sortable(sortable)
      raise "sortable must be a boolean." unless is_bool? sortable
      @sortable = sortable
      self
    end

    # Sets the field to be facetable.
    #
    # @param [TrueClass,FalseClass] facetable true or false.
    # @return [self] The current instance.
    def facetable(facetable)
      raise "facetable must be a boolean." unless is_bool? facetable
      @facetable = facetable
      self
    end

    # Sets the field to be the key (Only Edm.String fields can be keys).
    #
    # @param [TrueClass,FalseClass] key true or false.
    # @return [self] The current instance.
    def key(key)
      raise "key must be a boolean." unless is_bool? key
      raise "Only Edm.String fields can be keys." unless @type == "Edm.String"
      @key = key
      self
    end

    # Converts this IndexField to a Hash.
    #
    # @return [Hash] Hash representation of IndexField.
    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end
  end

end
