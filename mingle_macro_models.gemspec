module Mingle
  module MacroModels
    VERSION = "1.3.4"
  end
end

Gem::Specification.new do |spec|
  spec.name = "mingle_macro_models"
  spec.version = Mingle::MacroModels::VERSION
  spec.summary = "Wrapper models used by custom Mingle macros."
  spec.description = "Wrapper models used by custom Mingle macros."
  spec.author = "ThoughtWorks Inc"
  spec.email = 'support@thoughtworks.com'
  spec.license = 'MIT'
  spec.files = Dir['**/*'] - Dir['*.gemspec']
  spec.homepage = "https://github.com/ThoughtWorksStudios/mingle_macro_models"
end
