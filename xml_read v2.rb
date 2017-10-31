# require 'nokogiri'
require 'prettyprint'
require 'bing_translator'
# require 'yaml'
require_relative 'lib/translator'
require 'pp'
require 'fileutils'

# For dev only
FileUtils.rm 'data/already_translated.yml'
FileUtils.cp 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.1509440919.xml', 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'

debug = false
translator = Translator.new( debug )
infile = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'
outfile = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'

doc = File.open( infile ) { |f| Nokogiri::XML(f) }

FileUtils.cp infile, File.dirname( infile ) + '/' + File.basename( infile, '.xml' ) + '.' + Time.now.to_i.to_s + File.extname( infile )

doc.at('encounter').xpath('category').each do |category|
  category.children.each do |blocs|
    next if blocs.class == Nokogiri::XML::Text
    blocs.children.each do |data|
      next if data.class == Nokogiri::XML::Text || data.name != 'text'
      data.children.each do |texts_blocs|
        next if texts_blocs.class == Nokogiri::XML::Text
        translator.translate_text_bloc( texts_blocs )
      end
    end
  end
end

translator.save_data
File.write(outfile, doc.to_xml)