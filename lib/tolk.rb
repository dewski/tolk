require 'tolk/engine'
require 'tolk/keys'

module Tolk
  class LocaleNotFound < StandardError; end
  
  mattr_accessor :namespace
  self.namespace = ENV['TOLK_NAMESPACE'] || 'tolk'
  
  mattr_accessor :default_locale
  self.default_locale = ::I18n.default_locale.to_s
  
  mattr_accessor :locale
  self.locale = ::I18n.default_locale.to_s
  
  mattr_accessor :hit_check
  self.hit_check = true
  
  def self.hit_check?
    !!hit_check
  end

  def self.setup
    yield self
  end
  
  extend Keys
end
