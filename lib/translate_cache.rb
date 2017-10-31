require 'uri'
require 'easy_translate'
require 'openssl'
require 'yaml'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class TranslateCache

  CACHE_FILEPATH = 'data/translation_cache.yml'

  def initialize( debug = false )
    @cache = {}
    @cache = YAML.load_file( CACHE_FILEPATH ) if File.exist?( CACHE_FILEPATH )

    @key = File.read('keys/google')
    # For bing
    # @translator = BingTranslator.new(key, skip_ssl_verify: true)

    @debug = debug
  end

  def translate( data )
    if @cache.has_key?( data )
      puts 'Cache hit.'
      puts "for #{data}" if @debug
      return replace_odd_characters( @cache[ data ] )
    else
      puts 'Translating ...'
    end

    # For bing
    # translation = @translator.translate( data, to: 'fr' )

    # For google
    translation = google_translate( data )
    @cache[ data ] = translation
    @cache[ translation ] = replace_odd_characters( translation )
  end

  def save_cache()
    File.write( CACHE_FILEPATH, @cache.to_yaml)
  end

  def replace_odd_characters( string )
    string.gsub( '’', "'" )
  end

  private

  def google_translate( text )
    # EasyTranslate.translate( text, :to => :fr, key: @key )
  end


end

