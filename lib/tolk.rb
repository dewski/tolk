require 'tolk/engine'
require 'tolk/keys'

module Tolk
  class LocaleNotFound < StandardError; end
  
  class << self
    cattr_accessor :namespace
    self.namespace = ENV['TOLK_NAMESPACE'] || 'tolk'
    
    cattr_accessor :locale
    self.locale = ::I18n.default_locale.to_s
  end
  
  extend Keys
end
