class TranslateCache

  CACHE_FILEPATH = 'data/translation_cache.yml'

  def initialize
    @cache = {}
    @cache = YAML.load_file( CACHE_FILEPATH ) if File.exist?( CACHE_FILEPATH )

    key = File.read('data/subscription.key')
    @translator = BingTranslator.new(key, skip_ssl_verify: true)
  end

  def translate( data )
    p data

    if @cache.has_key?( data )
      puts "Cache hit for #{data}"
      return @cache[ data ]
    end

    translation = @translator.translate( data, to: 'fr' )
    @cache[ data ] = translation
    @cache[ translation ] = translation
  end

  def save_cache()
    File.write( CACHE_FILEPATH, @cache.to_yaml)
  end

end