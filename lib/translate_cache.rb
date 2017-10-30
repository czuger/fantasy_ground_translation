class TranslateCache

  CACHE_FILEPATH = 'data/translation_cache.yml'

  def initialize( debug = false )
    @cache = {}
    @cache = YAML.load_file( CACHE_FILEPATH ) if File.exist?( CACHE_FILEPATH )

    key = File.read('data/subscription.key')
    @translator = BingTranslator.new(key, skip_ssl_verify: true)

    @debug = debug
  end

  def translate( data )
    if @cache.has_key?( data )
      puts "Cache hit for #{data}" if @debug
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