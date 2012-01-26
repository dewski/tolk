require 'rails/engine'
require 'ya2yaml'
require 'will_paginate/array'
require 'will_paginate/view_helpers/action_view'
require 'redis'

require 'tolk/base'
require 'tolk/import'
require 'tolk/sync'

module Tolk
  class Engine < Rails::Engine
    isolate_namespace Tolk

    # Used as default namespace for routes
    engine_name :tolk
    
    initializer 'tolk.setup_redis' do
      $redis ||= Redis.new
    end
  end
end
