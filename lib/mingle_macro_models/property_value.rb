# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  class PropertyValue

    def initialize(property_value)
      @property_value = property_value
    end

    # *returns*: The display value of this value
    # Use the result of this method to display this value on the UI
    # For the various property types, the following are the values you can expect to see
    # * Managed/Unmanaged text    : The string value of the value
    # * Managed/Unmanaged numeric : The numeric string representation of the value
    # * Date                      : The list of values this property has on all cards on the project, formatted using the project date format
    # * User                      : The name of the user
    # * Formula                   : Either the date or the numeric value, formatted as above
    # * Card                      : The number of the card, followed by the name of the card
    def display_value
      @property_value.display_value
    end

    # *returns*: The identifier that is used to represent this value in the database
    # You will most likely not have to use this value in your macros
    # For the various property types, the following are the values you can expect to see
    # * Managed/Unmanaged text    : The string value of the value
    # * Managed/Unmanaged numeric : The numeric string representation of the value
    # * Date                      : The canonical date format, as stored in the database
    # * User                      : The id of the user in the database
    # * Formula                   : Either the date or the numeric value, formatted as above
    # * Card                      : The id of the card in the database
    def db_identifier
      @property_value.db_identifier
    end

    # *returns*: A representation of this value that is unique and representable in a URL
    # Use the result of this method if in any links that you want to build to point back into Mingle
    # For the various property types, the following are the values you can expect to see
    # * Managed/Unmanaged text    : The string value of the value
    # * Managed/Unmanaged numeric : The numeric string representation of the value
    # * Date                      : The list of values this property has on all cards on the project, formatted using the project date format
    # * User                      : The login of the user
    # * Formula                   : Either the date or the numeric value, formatted as above
    # * Card                      : The number of the card, followed by the name of the card
    def url_identifier
      @property_value.url_identifier
    end

    # *returns*: The hex color code for this PropertyValue
    def color
      @property_value.color.gsub('#', '')
    end

    # *returns*: The PropertyDefinition that this value belongs to
    def property_definition
      @property_definition_loader.load
    end

    def to_s
      "PropertyValue[display_value=#{display_value},db_identifier=#{db_identifier},url_identifier=#{url_identifier}]"
    end

    attr_writer :property_definition_loader

  end

end
