# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  # This is a lightweight representation of a card type in Mingle.
  # From an instance of this class you can the name, color and position of the card type,
  # in addition to Property Definitions that are associated with it.
  class CardType

    def initialize(full_card_type)
      @full_card_type = full_card_type
    end

    # *returns*: The name of this CardType
    def name
      @full_card_type.name
    end

    # *returns*: The hex color code for this CardType
    def color
      @full_card_type.color.gsub('#', '')
    end

    # *returns*: The position of this CardType among all the CardTypes on the project.
    # The first card type has position 1
    def position
      @full_card_type.position
    end

    # *returns*: The PropertyDefinitions associated with this CardType
    def property_definitions
      @card_types_property_definitions_loader.load.collect(&:property_definition)
    end

    def to_s
      "CardType[name=#{name},color=#{color},position=#{position}]"
    end

    attr_writer :card_types_property_definitions_loader
  end

end
