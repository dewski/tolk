require 'rails/engine'
require 'ya2yaml'
require 'will_paginate'

require 'tolk/import'
require 'tolk/sync'

module Tolk
  class Engine < Rails::Engine
    isolate_namespace Tolk

    # Used as default namespace for routes
    engine_name :tolk
  end
end
