module Tolk
  class Translation < Base
    attr_accessor :locale
    attr_accessor :phrase
    attr_accessor :value
    
    def initialize(locale, phrase)
      @locale = locale
      @key = phrase
      
      # HSET tolk.locales.es.map producer.title "Hola"
      @value = $redis.hget(key('locales', locale, 'map'), phrase)
    end
  end
end
