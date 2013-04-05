# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  # This is a lightweight representation of the relationship between a card_type
  # and a property definition as configured in Mingle.
  class CardTypePropertyDefinition
    def initialize(card_type_property_definition)
      @card_type_property_definition = card_type_property_definition
    end

    def position
      @card_type_property_definition.position.to_i
    end

    def card_type
      @card_type_loader.load
    end

    def property_definition
      @property_definition_loader.load
    end

    attr_writer :card_type_loader, :property_definition_loader
  end

end
