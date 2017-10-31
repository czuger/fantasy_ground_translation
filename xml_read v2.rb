# require 'nokogiri'
require 'prettyprint'
require 'bing_translator'
# require 'yaml'
require_relative 'lib/translate_cache'
require 'pp'

debug = false
t_cache = TranslateCache.new( debug )
infile = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel - Copie.xml'
outfile = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'

doc = File.open( infile ) { |f| Nokogiri::XML(f) }

def add_translated_bloc( t_cache, bloc, debug )
  tb = bloc.dup
  tb.content = t_cache.translate( bloc.text )
  bloc.add_next_sibling( tb )
end

# Ajouter un bloc entre parenthèses à la fin du text
def append_translated_bloc( t_cache, bloc )
  translation = t_cache.translate( bloc.text )
  bloc.content = "#{bloc.text} (#{translation})"
end

def translate_text_bloc( t_cache, text_bloc, debug )
  t = text_bloc
  if t.name == 'p'
    p "We have p : #{t.children.inspect}.count = #{t.children.count}" if debug
    if t.children.count > 1
      puts 'Translating multiple p' if debug
      t.children.each do |children|
        p "Children = " + children.inspect if debug
        translate_text_bloc( t_cache, children, debug )
      end
    else
      puts 'Translating single p' if debug
      append_translated_bloc( t_cache, t )
    end
  elsif t.name == 'b'
    puts 'Translating single b' if debug
    p t if debug
    append_translated_bloc( t_cache, t )
  elsif t.class == Nokogiri::XML::Text
    puts 'Translating sub text' if debug
    p t if debug
    append_translated_bloc( t_cache, t )

  elsif t.name == 'h'
    puts 'Translating header'  if debug
    append_translated_bloc( t_cache, t )

  elsif t.name == 'list'
    puts 'Translating list' if debug
    t.children.each do |children|
      p "Children = " + children.inspect if debug
      next if children.class == Nokogiri::XML::Text
      append_translated_bloc( t_cache, children.children.first )
    end

  elsif t.name == 'frame'
    puts 'Translating list' if debug
    add_translated_bloc( t_cache, t, debug )

  end
  # puts
end

doc.at('encounter').xpath('category').each do |category|
  category.children.each do |blocs|
    next if blocs.class == Nokogiri::XML::Text
    blocs.children.each do |data|
      next if data.class == Nokogiri::XML::Text || data.name != 'text'
      data.children.each do |texts_blocs|
        next if texts_blocs.class == Nokogiri::XML::Text
        translate_text_bloc( t_cache, texts_blocs, debug )
      end
    end
  end
end

t_cache.save_cache
File.write(outfile, doc.to_xml)