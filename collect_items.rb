require 'rubygems'
require 'mechanize'
agent = Mechanize.new
start_time = Time.now
page = agent.get('http://www.lolking.net/items')
#will retrieve the link for search result
result = page.search('.item-list').search('a')
item_keys = []
result.each do |f|
  item_keys << f['href'][7..32]
end
items = {}
item_keys.each do |g|
  item_page = agent.get('http://www.lolking.net/items/'+g)
  result = item_page.search('.headline').text
  items[g] = result
end
puts items
