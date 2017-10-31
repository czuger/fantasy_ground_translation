require_relative 'translate_cache'
require_relative 'translation_memory_keeper'

class Translator

  def initialize( debug )
    @translate_cache = TranslateCache.new( debug )
    @translation_memory_keeper = TranslationMemoryKeeper.new( debug )
    @debug = debug
  end

  def save_data
    @translate_cache.save_cache
    @translation_memory_keeper.save_mem
  end

  def translate_text_bloc( text_bloc )
    t = text_bloc
    if t.name == 'p'
      p "We have p : #{t.children.inspect}.count = #{t.children.count}" if @debug
      if t.children.count > 1
        puts 'Translating multiple p' if @debug
        t.children.each do |children|
          p "Children = " + children.inspect if @debug
          translate_text_bloc( children )
        end
      else
        puts 'Translating single p' if @debug
        append_translated_bloc( t )
      end
    elsif t.name == 'b'
      puts 'Translating single b' if @debug
      p t if @debug
      append_translated_bloc( t )
    elsif t.class == Nokogiri::XML::Text
      puts 'Translating sub text' if @debug
      p t if @debug
      # append_translated_bloc( t )

    elsif t.name == 'h'
      puts 'Translating header'  if @debug
      append_translated_bloc( t )

    elsif t.name == 'list'
      puts 'Translating list' if @debug
      t.children.each do |children|
        p "Children = " + children.inspect if @debug
        next if children.class == Nokogiri::XML::Text
        # append_translated_bloc( children.children.first )
      end

    elsif t.name == 'frame'
      puts 'Translating list' if @debug
      add_translated_bloc( t )

    end
    # puts
  end

  private

  def add_translated_bloc( bloc )
    unless @translation_memory_keeper.translated?( bloc.text )
      tb = bloc.dup
      tb.content = @translate_cache.translate( bloc.text )
      bloc.add_next_sibling( tb )
      @translation_memory_keeper.translated( bloc.text )
    end
  end

  # Ajouter un bloc entre parenthèses à la fin du text
  # def append_translated_bloc( bloc )
  #   unless @translation_memory_keeper.translated?( bloc.text )
  #     translation = @translate_cache.translate( bloc.text )
  #     bloc.content = "#{bloc.text} (#{translation})"
  #     @translation_memory_keeper.translated( bloc.text )
  #   end
  # end

  def append_translated_bloc( bloc )
    unless @translation_memory_keeper.translated?( bloc.text )
      translation = @translate_cache.translate( bloc.text )
      # bloc.content = "#{bloc.text} <i>(#{translation})</i>"
      p bloc
      bloc.add_child "<i>(#{translation})</i>"
      @translation_memory_keeper.translated( bloc.text )
    end
  end

end