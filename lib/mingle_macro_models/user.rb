#Copyright 2012 ThoughtWorks, Inc.  All rights reserved.
# A lightweight model of a user in Mingle.
module Mingle
  class User
    def initialize(full_user)
      @full_user = full_user
    end

    # *returns*: The login of the user as configured in Mingle
    def login
      @full_user.login
    end

    # *returns*: The full name of the user as configured in Mingle
    def name
      @full_user.name
    end

    # *returns*: The version control user name of the user as configured in Mingle
    def version_control_user_name
      @full_user.version_control_user_name
    end

    # *returns*: The email address of the user as configured in Mingle
    def email
      @full_user.email
    end
  end
end
