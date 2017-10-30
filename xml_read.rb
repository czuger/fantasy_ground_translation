# require 'nokogiri'
require 'bing_translator'
require 'yaml'

key = File.read('subscription.key')
translator = BingTranslator.new(key, skip_ssl_verify: true)
file = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales\moduledb\DD TYP The Sunless Citadel.xml'
translated_db = YAML.load_file('translation_cache.yml')

doc = File.open( file ) { |f| Nokogiri::XML(f) }

doc.xpath( '//locked' ).each do |t|
  # puts translator.translate(t.text, to: 'fr')
  t.content = 0
end

doc.xpath( '//p' ).each_with_index do |t, i|
  next if translated_db.include?( t.content )
  p "About to translate " + t.content
  t.content = translator.translate(t.text, to: 'fr')
  translated_db << t.content
  # break if i > 10
end

File.write(file, doc.to_xml)
# p translated_db.to_yaml

File.write('translation_cache.yml', translated_db.to_yaml)