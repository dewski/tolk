module Tolk
  class Base
    cattr_accessor :namespace
    self.namespace = 'tolk'
    
    cattr_accessor :primary_locale_name
    self.primary_locale_name = ::I18n.default_locale.to_s
    
    class << self
      def key(*args)
        [self.namespace, args].flatten.join('.')
      end
    end
    
    def key(*args)
      self.class.key(*args)
    end
  end
end