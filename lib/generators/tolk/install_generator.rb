require 'rails/generators/base'

module Tolk
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)
    desc 'Tolk Install'
    
    def copy_initializer
      copy_file 'tolk.rb', 'config/initializers/tolk.rb'
    end
  end
end
