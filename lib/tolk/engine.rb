# Gems
require 'rails/engine'
require 'ya2yaml'
require 'will_paginate/array'
require 'will_paginate/view_helpers/action_view'
require 'redis'
require 'jquery-rails'

# Internal
require 'tolk/base'
require 'tolk/import'
require 'tolk/sync'

# Lookup backends
require 'tolk/backend/redis'

module Tolk
  class Engine < Rails::Engine
    isolate_namespace Tolk

    # Used as default namespace for routes
    engine_name :tolk
    
    initializer 'tolk.setup_redis' do
      return unless $redis.nil?
      
      # Baked in support for Heroku
      if ENV.key?('REDISTOGO_URL')
        uri = URI.parse(ENV['REDISTOGO_URL'])
        $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
      else
        $redis = Redis.new
      end
    end
    
    initializer 'tolk.i18n_lookup' do
      I18n.backend = I18n::Backend::Chain.new(Tolk::Backend::Redis.new($redis), I18n.backend)
    end
  end
end
