module Hydra
  require 'hydra/workflow/datastream/workflow'
  module Workflow
    extend ActiveSupport::Autoload
    autoload :Collection
  end
end
