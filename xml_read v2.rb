require 'nokogiri'
require 'prettyprint'
# require 'bing_translator'
# require 'yaml'

file = 'C:\Program Files (x86)\Fantasy Grounds\Datas\campaigns\Tales 2\moduledb\DD TYP The Sunless Citadel.xml'

doc = File.open( file ) { |f| Nokogiri::XML(f) }

data =  doc.at('encounter').at('category').children[1].at('text').children

data.each do |t|
  # p t.class
  next if t.class == Nokogiri::XML::Text

  p t.name
  p t.children.count
  p t

  # t.add_next_sibling( t.dup )
end

# File.write(file, doc.to_xml)

# doc.xpath( '//p' ).each_with_index do |t, i|
#   next if translated_db.include?( t.content )
#   p "About to translate " + t.content
#   t.content = translator.translate(t.text, to: 'fr')
#   translated_db << t.content
#   # break if i > 10
# end