# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

module Mingle
  # This is a lightweight representation of a project.
  # From an instance of this class you can the name & identifier of the project.
  # You can also get a list of property definitions and card types on the project,
  # in addition to information about the team and project variables.
  # This class also provides an interface to the MQL execution facilities provided by Mingle.
  class Project

    VERSION_ONE = 'v1'
    VERSION_TWO = 'v2'

    def initialize(project, card_query_options)
      @full_project = project
      @card_query_options = card_query_options
    end

    # *returns*: The identifier of this project
    def identifier
      @full_project.identifier
    end

    # *returns*: The name of this project
    def name
      @full_project.name
    end

    # *returns*: A list CardTypes as configured for this project.
    # There will always be at least one element in this list.
    def card_types
      @card_types_loader.load.collect(&:card_type)
    end

    # *returns*: An list of PropertyDefinitions as configured for this project, which may be empty
    def property_definitions
      @property_definitions_loader.load.collect(&:property_definition)
    end

    # *accepts*: The name of a project variable configured for this project
    #
    # *returns*: The display value of the PropertyValue(s) that project_variable_name represents
    def value_of_project_variable(project_variable_name)
      @project_variables_loader.load.detect { |pv| pv.name == project_variable_name }.value
    end

    # *accepts*: A valid MQL string. To see what constitutes valid MQL,
    # look here[http://studios.thoughtworks.com/mingle-agile-project-management/3.0/help/index.html]
    #
    # *returns*: An Array of Hashes, in which each Hash represents one row of results from the MQL execution
    # The keys in the Hash are the names of the properties selected, with all the alphanumeric characters
    # downcased and all the spaces and special characters replaced with underscores(_).
    #
    # Executing a mql statement with explictly supplied property names will return results as follows
    # mql = select number,"defect status" where type=defect
    #
    # [
    #   {"number"=>"106", "defect_status"=>"Fixed"},
    #   {"number"=>"70", "defect_status"=>"Fixed"},
    #   {"number"=>"69", "defect_status"=>"New"},
    #   {"number"=>"68", "defect_status"=>"In Progress"},
    #   ...
    #   ...
    # ]
    #
    # If aggregate functions are selected, the values look as below
    # mql = select "defect status", count(*) where type=defect group by "defect status"
    #
    # [
    #   {"count"=>"14", "defect_status"=>"New"},
    #   {"count"=>"3", "defect_status"=>"Open"},
    #   {"count"=>"1", "defect_status"=>"In Progress"},
    #   {"count"=>"2", "defect_status"=>"Fixed"},
    #   {"count"=>"1", "defect_status"=>"Closed"}
    # ]
    #
    # If no columns are explicitly provided, the results contain the raw column names specific
    # properties. It is not possible to interpret these results in the general case with the current
    # version of the macro development toolkit, so this is not a particularly useful form of
    # MQL to execute. The documentation here is provided here just for completeness and should
    # not be used as a recommended way of using this call. The structure of this response is
    # subject to change in future versions of the toolkit.
    #
    # mql = type=defect
    #
    # {
    #   "cp_testing_status"=>"Ready to Be Tested",
    #   "cp_actual_effort"=>nil,
    #   "created_at"=>"2009-09-09 21:45:34",
    #   "cp_story_count"=>nil,
    #   "caching_stamp"=>"2",
    #   "cp_release_card_id"=>"2",
    #   "cp_risk_liklihood"=>nil,
    #   "cp_build_completed"=>"452",
    #   "cp_closed"=>nil,
    #   "has_macros"=>"f",
    #   "description"=>"",
    #   "cp_release_start_date"=>nil,
    #   "cp_risk_status"=>nil,
    #   "cp_story_time_to_life"=>nil,
    #   "cp_total_open_iterations"=>nil,
    #   "cp_defect_time_to_life"=>"50.00",
    #   "cp_development_started_on"=>nil,
    #   "card_type_name"=>"Defect",
    #   "cp_added_to_scope_on"=>nil,
    #   "cp_owner_user_id"=>nil,
    #   "cp_added_to_scope_card_id"=>nil,
    #   "cp_type_of_test"=>nil,
    #   "cp_velocity"=>nil,
    #   "cp_feature_card_id"=>"60"
    # }
    #
    # Note: In versions of the toolkit beyond 1.3, the keys for the aggregate function
    # (such as COUNT, SUM etc.) have been normalized to follow the same conventions as a
    # property name, i.e. lowecase and stripped of all spaces.
    # If you wish to get the results in the old form, set the optional second parameter
    # of this call to be Project::VERSION_ONE, while you transition your macros to use the new form.
    # The old version of response will be deprecated in a future version of Mingle and the toolkit.
    def execute_mql(mql, version = VERSION_TWO)
      @full_project.with_active_project do
        CardQuery.parse(mql, @card_query_options).values_for_macro(:api_version => version)
      end
    end

    # The macros on a page determine whether the page content is cached.  Macros that use certain MQL concepts
    # (for example TODAY, CURRENT USER, or cross-project functionality) should report that they cannot be
    # cached so that the page they are on is not cached.  This method indicates whether a MQL query uses
    # those concepts, and can be used by a macro to determine whether or not to report that it should be
    # cached.
    #
    # *accepts*: A valid MQL string. To see what constitutes valid MQL,
    # look here[http://studios.thoughtworks.com/mingle-agile-project-management/3.0/help/index.html]
    #
    # *returns*: A boolean indicating whether the data pertaining to the MQL can be cached
    def can_be_cached?(mql)
      @full_project.with_active_project do
        CardQuery.parse(mql, @card_query_options).can_be_cached?
      end
    end

    # *returns*: The full list of Users who are members of this project
    def team
      @team_loader.load
    end

    # *accepts*: Any Number
    #
    # *returns*: The argument number formatted to the precision configured for the project (default 2)
    def format_number_with_project_precision(number)
      @full_project.to_num(number)
    end

    # *accepts*: Any Number
    #
    # *returns*: The argument date formatted using the date format configured for the project
    def format_date_with_project_date_format(date)
      @full_project.format_date(date)
    end

    attr_writer :card_types_loader, :property_definitions_loader, :team_loader, :project_variables_loader

    private
    def add_alert(message)
      @card_query_options[:alert_receiver].alert(message) if @card_query_options[:alert_receiver]
    end
  end

end
