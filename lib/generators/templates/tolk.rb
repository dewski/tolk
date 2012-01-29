Tolk.setup do |config|
  # The storage namespace for Tolk, if for whatever reason you already have
  # keys stored with the tolk namespace, you can change this, although you
  # shouldn't have to change this.
  # config.namespace = 'tolk'
  
  # If you already have a Redis connection established elswhere, uncomment this
  # line or else Tolk will create it's own internally.
  # config.redis = $redis
  
  # If you want to enable Google Translate for missing phrases, insert your key
  # below. You may also use the GOOGLE_TRANSLATE_API_KEY environment variable
  # which is most recommended.
  # config.google_translate_key = ENV['GOOGLE_TRANSLATE_API_KEY']
  
  # The internal default locale which is the fallback for missing phrases.
  # You shouldn't have to change this line.
  # config.default_locale = ::I18n.default_locale.to_s
  
  # When a phrase is looked up, Tolk keeps track if it was a successful
  # lookup, or if it failed available as counters for you to understand
  # which phrases are the most important for your application.
  # config.hit_check = true
end