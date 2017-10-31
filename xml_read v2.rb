# require 'nokogiri'
require 'prettyprint'
# require 'bing_translator'
# require 'yaml'
require_relative 'lib/translator'
require_relative 'lib/xml_handler'
require 'pp'
require 'fileutils'

# For dev only
FileUtils.rm 'data/already_translated.yml' if File.exist? 'data/already_translated.yml'
FileUtils.cp 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.1509440919.xml', 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'

debug = false
infile = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'

FileUtils.cp infile, File.dirname( infile ) + '/' + File.basename( infile, '.xml' ) + '.' + Time.now.to_i.to_s + File.extname( infile )

xh = XmlHandler.new( infile, debug )

xh.dump

exit

translator.save_data
File.write(outfile, doc.to_xml)