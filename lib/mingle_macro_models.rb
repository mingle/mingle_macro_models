# Copyright 2009 - 2013 ThoughtWorks, Inc.  All rights reserved.

Dir.glob(File.join(File.dirname(__FILE__), "mingle_macro_models", "*.rb")).each do |file|
  require file
end
