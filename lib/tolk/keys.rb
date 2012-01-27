module Tolk
  module Keys
    # Public: Returns Redis lookup key based on any number of arguments
    # joined by a period with the namespace as a prefix.
    #
    # Examples:
    #
    #   Tolk.key('hello')
    #   # => 'tolk.hello'
    #
    #   Tolk.namespace = 'github'
    #   Tolk.key('hello')
    #   # => 'github.hello'
    #
    #
    # Returns the String joined by periods.
    def key(*args)
      [self.namespace, args].flatten.join('.')
    end
    
    def phrase_key
      key('phrases')
    end
    
    def phrases_key(key=nil)
      key('phrases', key || locale)
    end
    
    def phrases_miss_key(key=nil)
      key('phrases', key || locale, 'misses')
    end
    
    def phrase_lookup_key(key=nil)
      key('phrases', key || locale, 'map')
    end
    
    def phrase_list_key(key=nil)
      key('phrases', key || locale, 'listing')
    end
    
    def phrase_miss_list_key(key=nil)
      key('phrases', key || locale, 'listing', 'miss')
    end
    
    def phrase_hit_list_key(key=nil)
      key('phrases', key || locale, 'listing', 'hit')
    end
    
    def locales_key
      key('locales')
    end
    
    def locale_key(key=nil)
      key('locales', key || locale)
    end
    
    def lookup_value_key(lookup_key, key=nil)
      key('locales', key || locale, 'values', lookup_key)
    end
  end
end