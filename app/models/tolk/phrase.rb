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
      
      def missing_keys(locale=nil)
        ($redis.sdiff(Tolk.phrase_key, Tolk.phrases_key) + $redis.sdiff(Tolk.phrases_miss_key(locale), Tolk.phrases_key)).flatten.uniq
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
      ($redis.get(Tolk.value_miss_key(key)) || '0').to_i
    end
    
    # Public: Return the amount of times the current phrase has been attempted to be looked up
    def hits
      ($redis.get(Tolk.value_hit_key(key)) || '0').to_i
    end
    
    # Public: Sets attributes
    def update_attributes(attributes)
      attributes.each { |k, v| send(:"#{k}=", v) }
      save
    end
    
    # Public:
    def reset
      $redis.set(Tolk.value_miss_key(key), 0)
      $redis.set(Tolk.value_hit_key(key), 0)
    end
    
    # Public: Saves the key and value of the phrase into the data store
    def save
      $redis.srem(Tolk.phrases_miss_key, @key)
      $redis.set(Tolk.value_miss_key(key), 0)
      
      $redis.sadd(Tolk.phrase_key, @key) unless $redis.sismember(Tolk.phrase_key, @key)
      
      # Critical Important
      $redis.sadd(Tolk.phrases_key, @key) && $redis.hset(Tolk.phrase_lookup_key, @key, @value)
    end
    
    # Public: Destroys any associated keys, sets, or lists associated to the phrase
    def destroy
      $redis.srem(Tolk.phrase_key, @key)
      $redis.srem(Tolk.phrases_key, @key)
      $redis.hdel(Tolk.phrase_lookup_key, @key)
      $redis.del(Tolk.value_miss_key(key))
      $redis.del(Tolk.value_hit_key(key))
    end
    
    def to_param
      key
    end
  end
end
