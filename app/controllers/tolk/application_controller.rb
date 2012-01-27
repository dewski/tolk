module Tolk
  class ApplicationController < ActionController::Base
    protect_from_forgery
    helper :all
    rescue_from Tolk::LocaleNotFound do
      redirect_to locales_path
    end

    cattr_accessor :authenticator
    before_filter :authenticate
    
    before_filter :check_for_locales
    before_filter :set_locale

    def authenticate
      self.authenticator.bind(self).call if self.authenticator && self.authenticator.respond_to?(:call)
    end
    
    def current_locale
      @current_locale ||= Tolk::Locale.find!(Tolk.locale)
    end
    helper_method :current_locale
    
    def check_for_locales
      Tolk::Locale.create!(I18n.default_locale.to_s) if $redis.smembers(Tolk.locales_key).reject(&:blank?).empty?
    end
 
    def set_locale
      I18n.locale = Tolk.locale = params[:locale_id] || params[:id] || I18n.default_locale.to_s
    end
  end
end
