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

  def translate_text_bloc( formatted_text_bloc, text_bloc )
    if text_bloc.name == 'p'
      translate_p( text_bloc )
    elsif text_bloc.name == 'b'
      puts 'Translating single b' if @debug
      p text_bloc if @debug
      store_children_translated_bloc(formatted_text_bloc, text_bloc )
    elsif text_bloc.class == Nokogiri::XML::Text
      puts 'Translating sub text' if @debug
      p text_bloc if @debug
      # append_translated_bloc( t )

    elsif text_bloc.name == 'h'
      puts 'Translating header'  if @debug
      store_children_translated_bloc(formatted_text_bloc, text_bloc )

    elsif text_bloc.name == 'list'
      puts 'Translating list' if @debug
      text_bloc.children.each do |children|
        p "Children = " + children.inspect if @debug
        next if children.class == Nokogiri::XML::Text
        # append_translated_bloc( children.children.first )
      end

    elsif text_bloc.name == 'frame'
      puts 'Translating list' if @debug
      store_children_translated_bloc(formatted_text_bloc, text_bloc )

    end
    # puts
  end

  private

  def translate_p( text_bloc )
    p "We have p : #{text_bloc.children.inspect}.count = #{text_bloc.children.count}" if @debug
    if text_bloc.children.count > 1
      puts 'Translating multiple p' if @debug
      text_bloc.children.each do |children|
        p "Children = " + children.inspect if @debug
        translate_text_bloc( formatted_text_bloc, children )
      end
    else
      puts 'Translating single p' if @debug
      store_children_translated_bloc(formatted_text_bloc, text_bloc )
    end
  end

  def store_children_translated_bloc(formatted_text_bloc, text_bloc )
    unless @translation_memory_keeper.translated?( text_bloc.text )

      tb = text_bloc.dup
      tb.content = @translate_cache.translate( text_bloc.text )
      formatted_text_bloc.children.before( tb )
      @translation_memory_keeper.translated( text_bloc.text )
    end
  end

  # def add_translated_bloc( bloc )
  #   unless @translation_memory_keeper.translated?( bloc.text )
  #     tb = bloc.dup
  #     tb.content = @translate_cache.translate( bloc.text )
  #     bloc.add_next_sibling( tb )
  #     @translation_memory_keeper.translated( bloc.text )
  #   end
  # end
  #
  # # Ajouter un bloc entre parenthèses à la fin du text
  # # def append_translated_bloc( bloc )
  # #   unless @translation_memory_keeper.translated?( bloc.text )
  # #     translation = @translate_cache.translate( bloc.text )
  # #     bloc.content = "#{bloc.text} (#{translation})"
  # #     @translation_memory_keeper.translated( bloc.text )
  # #   end
  # # end
  #
  # def append_translated_bloc( bloc )
  #   unless @translation_memory_keeper.translated?( bloc.text )
  #     translation = @translate_cache.translate( bloc.text )
  #     # bloc.content = "#{bloc.text} <i>(#{translation})</i>"
  #     p bloc
  #     bloc.add_child "<i>(#{translation})</i>"
  #     @translation_memory_keeper.translated( bloc.text )
  #   end
  # end

end