module Tolk
  class Phrase < Base
    class << self
      # Public
      def lookup(set, phrase)
        translation = $redis.hget(Tolk.phrase_lookup_key, phrase)
        self.new(phrase, translation)
      end
      
      def find(key)
        self.new(key)
      end
      
      # Public: Returns all
      def all
        keys.collect { |phrase| self.new(phrase) }
      end
      
      # Public: Returns all
      def localized
        localized_keys.collect { |phrase| self.new(phrase) }
      end
      
      # Public: Lookup any keys that were attempted to be looked up but didn't have any localization.
      #
      # locale - The locale key, defaults to primary locale
      #
      # Examples:
      #
      #   Tolk::Phrase.attempted_lookups
      #   # => ['Hello World!', 'How is it going?']
      #
      #   Tolk::Phrase.attempted_lookups('fr')
      #   # => ['French Fries']
      #
      def attempted_lookups(locale=nil)
        $redis.smembers(Tolk.phrases_miss_key).collect { |phrase| self.new(phrase) }
      end
      
      # Public: Gathers all phrases across all locales, fullfilled or not
      #
      # Examples:
      #
      #   Tolk::Phrases.keys
      #   # => ['page.title', 'page.footer.text']
      #
      def keys
        $redis.smembers(Tolk.phrase_key)
      end
      
      # Public: Gathers all phrases across all locales, fullfilled or not
      #
      # Examples:
      #
      #   Tolk::Phrases.keys
      #   # => ['page.title', 'page.footer.text']
      #
      def localized_keys
        $redis.smembers(Tolk.phrase_key)
      end
      
      def missing_for_locale(locale=nil)
        missing_keys_for_locale(locale).collect { |phrase| self.new(phrase) }
      end
      
      def missing_keys_for_locale(locale)
        missing_keys(locale)
      end
      
      def missing_keys(locale=nil, start=0, stop=-1)
        $redis.zrevrange(Tolk.phrase_miss_list_key(locale), start, stop)
      end
    end
    
    attr_accessor :key
    attr_accessor :value
    
    def initialize(key, value=nil)
      @key = key
      @value = value || $redis.hget(Tolk.phrase_lookup_key, @key)
    end
    
    # Public: Return the amount of times the current phrase has been attempted to be looked up
    def misses
      $redis.zscore(Tolk.phrase_miss_list_key, key) || 0
    end
    
    # Public: Return the amount of times the current phrase has been attempted to be looked up
    def hits
      $redis.zscore(Tolk.phrase_hit_list_key, key) || 0
    end
    
    def translate
      self.value = key.translate(Tolk.locale, :from => Tolk.default_locale)
      save
    end
    
    # Public: Sets attributes
    def update_attributes(attributes)
      attributes.each { |k, v| send(:"#{k}=", v) }
      save
    end
    
    # Public:
    def reset
      $redis.zadd(Tolk.phrase_miss_list_key(key), 0, key)
      $redis.zadd(Tolk.phrase_hit_list_key(key), 0, key)
    end
    
    # Public: Saves the key and value of the phrase into the data store
    # TODO: Check for new record before doing zadd
    def save
      # Remove the miss list
      $redis.zrem(Tolk.phrase_miss_list_key, key)
      
      # Add it to the global list of phrases unless it already exists
      $redis.sadd(Tolk.phrase_key, key) unless $redis.sismember(Tolk.phrase_key, key)
      
      # Critical Important
      $redis.hset(Tolk.phrase_lookup_key, key, value) && $redis.zadd(Tolk.phrase_list_key, 0, key)
    end
    
    # Public: Returns the key of the phrase
    #
    # Examples:
    #
    #   phrase.to_param
    #   # => Hello, World!
    #
    #   phrase.to_param
    #   # => page.about.title
    #
    def to_param
      key
    end
    
    # Public: Destroys any associated keys, sets, or lists associated to the phrase
    def destroy
      $redis.srem(Tolk.phrase_key, key)
      $redis.srem(Tolk.phrases_key, key)
      $redis.hdel(Tolk.phrase_lookup_key, key)
      $redis.zrem(Tolk.phrase_list_key, key)
      $redis.zrem(Tolk.phrase_miss_list_key, key)
      $redis.zrem(Tolk.phrase_hit_list_key, key)
      $redis.del(Tolk.value_hit_key(key))
    end
  end
end
