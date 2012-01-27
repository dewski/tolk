module Tolk
  class Locale < Base
    MAPPING = {
      'ar'    => 'Arabic',
      'bs'    => 'Bosnian',
      'bt'    => 'Bulgarian',
      'ca'    => 'Catalan',
      'cz'    => 'Czech',
      'da'    => 'Danish',
      'de'    => 'German',
      'dsb'   => 'Lower Sorbian',
      'el'    => 'Greek',
      'en'    => 'English',
      'es'    => 'Spanish',
      'et'    => 'Estonian',
      'fa'    => 'Persian',
      'fi'    => 'Finnish',
      'fr'    => 'French',
      'he'    => 'Hebrew',
      'hr'    => 'Croatian',
      'hsb'   => 'Upper Sorbian',
      'hu'    => 'Hungarian',
      'id'    => 'Indonesian',
      'is'    => 'Icelandic',
      'it'    => 'Italian',
      'jp'    => 'Japanese',
      'ko'    => 'Korean',
      'lo'    => 'Lao',
      'lt'    => 'Lithuanian',
      'lv'    => 'Latvian',
      'mk'    => 'Macedonian',
      'nl'    => 'Dutch',
      'no'    => 'Norwegian',
      'pl'    => 'Polish',
      'pt-BR' => 'Portuguese (Brazilian)',
      'pt-PT' => 'Portuguese (Portugal)',
      'ro'    => 'Romanian',
      'ru'    => 'Russian',
      'se'    => 'Swedish',
      'sk'    => 'Slovak',
      'sl'    => 'Slovenian',
      'sr'    => 'Serbian',
      'sw'    => 'Swahili',
      'th'    => 'Thai',
      'tr'    => 'Turkish',
      'uk'    => 'Ukrainian',
      'vi'    => 'Vietnamese',
      'zh-CN' => 'Chinese (Simplified)',
      'zh-TW' => 'Chinese (Traditional)'
    }
    
    class << self
      def available_locales
        $redis.smembers(Tolk.locales_key).collect { |locale| self.new(locale) }
      end
      
      def primary_locale
        find(Tolk.locale)
      end
      
      def primary_language_name
        primary_locale.language_name
      end
      
      def create!(name)
        if locale = find(name)
          locale
        else
          $redis.sadd(Tolk.locales_key, name)
          self.new(name)
        end
      end
      
      def find(name)
        self.new(name) if has_locale?(name)
      end
      
      def find!(name)
        locale = find(name)
        raise MissingLocaleError if locale.nil?
        locale
      end
      
      private
      
      def has_locale?(name)
        $redis.sismember(Tolk.locales_key, name)
      end
    end
    
    attr_accessor :name
    attr_accessor :language_name
    
    def initialize(name)
      @name = name
      @language_name = MAPPING[name]
    end
    
    # @return boolean
    def save
      unless $redis.sismember(key('locales'))
        $redis.sadd(key('locales'), name)
      else
        true
      end
    end
    
    # @return boolean
    def primary?
      name == Tolk.locale
    end
    
    def phrases(start=0, stop=-1)
      set = Tolk.locale_key
      $redis.lrange(set, start, stop).collect { |phrase| Tolk::Phrase.new(set, phrase) }
    end
    
    def missing_phrases
      Tolk::Phrase.missing_for_locale(name)
    end
    
    def missing_keys
      Tolk::Phrase.missing_keys(name)
    end
    
    def missing_phrases_count
      missing_keys.length
    end
    
    def destroy
      $redis.srem(Tolk.locales_key)
    end
    
    def to_param
      name
    end
  end
end
