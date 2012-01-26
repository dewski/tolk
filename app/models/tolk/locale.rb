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
        $redis.smembers(key('locales')).collect { |locale| self.new(locale) }
      end
      
      def primary_locale
        find(primary_locale_name)
      end
      
      def primary_language_name
        primary_locale.language_name
      end
      
      def create!(locale)
        raise 'MissingLocaleError' if locale.nil?
        $redis.sadd(key('locales'), locale)
      end
      
      def find(name)
        self.new(name) if has_locale?(name)
      end
      alias :find_by_name :find
      
      def find_by_name!(name)
        locale = find_by_name(name)
        raise 'MissingLocaleError' unless locale
        
        locale
      end
      
      protected
      
      def has_locale?(name)
        $redis.sismember(key('locales'), name)
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
      $redis.sadd(key('locales'), name)
    end
    
    # @return boolean
    def primary?
      name == self.class.primary_locale_name
    end
    
    def phrases(start=0, stop=-1)
      set = key('locales', name)
      
      $redis.lrange(set, start, stop).collect { |phrase| Tolk::Phrase.lookup(set, phrase) }
    end
    
    def phrases_without_translation
      Tolk::Phrase.missing_for_locale(name)
    end
    
    def count_phrases_without_translation
      phrases_without_translation.length
    end
    
    def to_param
      name
    end
  end
end
