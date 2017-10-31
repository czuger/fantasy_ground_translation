require 'set'

class TranslationMemoryKeeper

  MEMORY_FILEPATH = 'data/already_translated.yml'

  def initialize( debug = false )
    @mem = Set.new
    @mem = YAML.load_file( MEMORY_FILEPATH ) if File.exist?( MEMORY_FILEPATH )

    @debug = debug
  end

  def translated( text )
    @mem << text
  end

  def translated?( text )
    @mem.include?( text )
  end

  def save_mem()
    File.write( MEMORY_FILEPATH, @mem.to_yaml)
  end

end

