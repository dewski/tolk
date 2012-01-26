module Tolk
  class Phrase < Base
    class << self
      def lookup(set, phrase)
        translation = $redis.hget("#{set}.map", phrase)
        self.new(phrase, translation)
      end
      
      def all
        $redis.smembers(key('phrases'))
      end
      
      def missing_for_locale(locale)
        all.delete_if { |phrase| !$redis.hget(key('locales', locale, 'map'), phrase).nil? }
      end
    end
    
    attr_accessor :phrase
    attr_accessor :value
    
    def initialize(phrase, value)
      @phrase = phrase
      @value = value
    end
  end
end
