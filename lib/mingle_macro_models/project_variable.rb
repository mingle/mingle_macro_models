# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  # This is a lightweight representation of a ProjectVariable in Mingle
  # A property defintion is a mnemonic name that represents a particular
  # value for one or more PropertyDefinitions
  class ProjectVariable

    def initialize(full_project_variable)
      @full_project_variable = full_project_variable
    end

    # *returns*: The name of this variable
    def name
      @full_project_variable.name
    end

    # *returns*: The display value of the value configured for this project variable
    def value
      @full_project_variable.display_value
    end
  end

end
