require 'rubygems'
require 'mechanize'
agent = Mechanize.new
puts "Enter player to find:"
player_name = gets
start_time = Time.now
page = agent.get('http://www.lolking.net/summoner/na/25087996')
#will retrieve the link for search result
puts page
end_time = Time.now
puts "Took #{((end_time - start_time)*1000)} milliseconds to look up the player"
