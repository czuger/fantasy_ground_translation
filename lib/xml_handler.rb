require 'nokogiri'
require_relative 'translator'

class XmlNode
  def initialize( data, tab_count )
    @xml_node = data
    @data = data.text
    @tabl_count = tab_count
  end
  def dump
    puts "\t\t\t" + "(#{@xml_node.name}) : " + @data
  end
end

class XmlList
  def initialize( data )
    @xml_node = data
    @data = []
    data.children.each do |children|
      p children
      next if children.class == Nokogiri::XML::Text
      @data << XmlNode.new( children )
    end
  end
  def dump
    puts "\t\t\t" + @xml_node.name
    @data.each do |data|
      data.dump
    end
  end
end

class XmlFormattedText
  def initialize( translator, f_text )
    @xml_node = f_text
    @data = []
    f_text.children.each do |text_bloc|
      next if text_bloc.class == Nokogiri::XML::Text
      # @data << translator.translate_text_bloc( formatted_text_bloc, texts_blocs )
      if text_bloc.name == 'list'
        @data << XmlList.new( text_bloc )
      else
        @data << XmlNode.new( text_bloc )
      end

    end
  end
  def dump
    puts "\t\t" + @xml_node.name
    @data.each do |data|
      data.dump
    end
  end
end

class XmlEnc
  def initialize( translator, encounter )
    @xml_node = encounter
    @data = []
    encounter.children.each do |formatted_text_bloc|
      next if formatted_text_bloc.class == Nokogiri::XML::Text || formatted_text_bloc.name != 'text'
      @data << XmlFormattedText.new( translator, formatted_text_bloc )
    end
  end
  def dump
    puts "\t" + @xml_node.name
    @data.each do |data|
      data.dump
    end
  end
end

class XmlCategory
  def initialize( translator, no_categ )
    @xml_node = no_categ
    @data = []
    no_categ.children.each do |encounter|
      next if encounter.class == Nokogiri::XML::Text
      @data << XmlEnc.new( translator, encounter )
    end
  end
  def dump
    puts @xml_node.attributes.first.last.value
    @data.each do |data|
      data.dump
    end
  end
end

class XmlHandler

  def initialize( xml_filename, debug = false )
    @xml_filename = xml_filename
    @doc = File.open( @xml_filename ) { |f| Nokogiri::XML(f) }
    @data = []
    @translator = Translator.new( debug )
    read_xml
  end

  def read_xml
    @doc.at('encounter').xpath('category').each do |category|
      @data << XmlCategory.new( @translator, category )
    end
  end

  def dump
    @data.each do |data|
      data.dump
    end
  end

end