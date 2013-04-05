# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  # This is a lightweight representation of a ProjectDefinition in Mingle
  class PropertyDefinition

    MANAGED_TEXT_TYPE = "Managed text list"
    ANY_TEXT_TYPE = "Any text"
    MANAGED_NUMBER_TYPE = "Managed number list"
    ANY_NUMBER_TYPE = "Any number"
    DATE_TYPE = "Date"
    FORMULA_TYPE = "Formula"
    USER_TYPE = "Automatically generated from the team list"
    CARD_TYPE = "Card"
    AGGREGATE_TYPE = "Aggregate"
    TREE_RELATIONSHIP_TYPE = "Any card used in tree"

    def initialize(full_property_definition)
      @full_property_definition = full_property_definition
    end

    # *returns*: The name of this PropertyDefinition
    def name
      @full_property_definition.name
    end

    # *returns*: The description of this PropertyDefinition
    def description
      @full_property_definition.description
    end

    # *returns*: A list of CardTypes that this PropertyDefinition is valid for
    def card_types
      @card_types_property_definitions_loader.load.collect(&:card_type).sort_by(&:position)
    end

    # *returns*: A short description of the property definition.
    # This will be one of the above values
    # - MANAGED_TEXT_TYPE
    # - ANY_TEXT_TYPE
    # - MANAGED_NUMBER_TYPE
    # - ANY_NUMBER_TYPE
    # - DATE_TYPE
    # - FORMULA_TYPE
    # - USER_TYPE
    # - CARD_TYPE
    # - AGGREGATE_TYPE
    # - TREE_RELATIONSHIP_TYPE
    def type_description
      @full_property_definition.type_description
    end

    # *returns*: A list of explicitly defined values that this PropertyDefinition has
    # This method should ONLY be called for property definitions that are of the following types
    # - MANAGED_TEXT_TYPE
    # - MANAGED_NUMBER_TYPE
    # - USER_TYPE
    #
    # Attempting to call this method for the following types will throw an Exception
    # - ANY_TEXT_TYPE
    # - ANY_NUMBER_TYPE
    # - FORMULA_TYPE
    # - AGGREGATE_TYPE
    # - CARD_TYPE
    # - TREE_RELATIONSHIP_TYPE
    # - DATE_TYPE
    #
    # To get the values for the above types, you can use MQL, such as "SELECT property_name" to get
    # a list of values
    def values
      valid_property_types_to_call_value_on = [MANAGED_TEXT_TYPE, MANAGED_NUMBER_TYPE, USER_TYPE]
      unless valid_property_types_to_call_value_on.any? {|t| self.type_description == t}
        raise "Do not call this method for property definitions of types other than MANAGED_TEXT_TYPE, MANAGED_NUMBER_TYPE, USER_TYPE."
      end
      @values_loader.load
    end

    # *returns*: True if a property definition has only textual values, such as ones of Un/managed text types
    def textual?
      type_description == MANAGED_TEXT_TYPE || type_description == ANY_TEXT_TYPE
    end

    # *returns*: True if a property definition has only numeric values, such as ones of Un/managed number types
    def numeric?
      type_description == MANAGED_NUMBER_TYPE || type_description == ANY_NUMBER_TYPE
    end

    # *returns*: True if a property definition has only calculated values, such as ones of Formula & Aggregate types
    def calculated?
      type_description == FORMULA_TYPE || type_description == AGGREGATE_TYPE
    end

    # *returns*: True if a property definition has only numeric values, such as the Date type
    def date?
      type_description == DATE_TYPE
    end

    def to_s
      "PropertyDefinition[name=#{name},type=#{type}]"
    end

    attr_writer :card_types_property_definitions_loader, :values_loader
  end

end
