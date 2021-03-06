Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = '1.0'
  s.summary     = 'Rails engine providing web interface for managing i18n yaml files'
  s.description = 'Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.'

  s.author = 'David Heinemeier Hansson'
  s.email = 'david@loudthinking.com'
  s.homepage = 'http://www.rubyonrails.org'

  s.platform = Gem::Platform::RUBY
  s.add_dependency 'will_paginate', '3.0.2'
  s.add_dependency 'ya2yaml', '~> 0.26'
  s.add_dependency 'redis'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'i18n'
  s.add_dependency 'to_lang'

  s.files = Dir['README.md', 'CHANGELOG.md', 'MIT-LICENSE', '{lib,app,db,config}/**/*']
  s.has_rdoc = false

  s.require_path = 'lib'
end
