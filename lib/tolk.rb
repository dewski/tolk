require 'tolk/engine'
require 'tolk/keys'

module Tolk
  class LocaleNotFound < StandardError; end
  
  mattr_accessor :namespace
  self.namespace = ENV['TOLK_NAMESPACE'] || 'tolk'
  
  mattr_accessor :google_translate_key
  self.google_translate_key = ENV['GOOGLE_TRANSLATE_API_KEY']
  
  mattr_accessor :default_locale
  self.default_locale = ::I18n.default_locale.to_s
  
  mattr_accessor :locale
  self.locale = ::I18n.default_locale.to_s
  
  mattr_accessor :hit_check
  self.hit_check = true
  
  def self.hit_check?
    !!hit_check
  end
  
  # Public: Only time a key can be present is if it's a string, any boolean
  # will return false here as a key needs to be passed.
  def self.google_translate?
    google_translate_key.is_a?(String)
  end

  def self.setup
    yield self
  end
  
  extend Keys
end
