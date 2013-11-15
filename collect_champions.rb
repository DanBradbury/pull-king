require 'rubygems'
require 'mechanize'
agent = Mechanize.new
start_time = Time.now
page = agent.get('http://www.lolking.net/champions/')
result = page.search('tr')
print "{"
result.each do |f|
  # proper champion name
  print "\"" + f.children[0].children[3].children.attr('href').content[11..36] + "\" => " if f.children[0].children[3]
  print "\"" + f.children[0].children[3].children.text+ "\", " if f.children[0].children[3]
end
print "}"

