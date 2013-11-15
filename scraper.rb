require 'rubygems'
require 'mechanize'
require 'active_support'

class Scraper

  def initialize(i, r, l)
    @id, @region, @log = i, r, l
    @match_history = "http://www.lolking.net/summoner/"+@region.to_s+"/"+@id.to_s+"#history"
  end
  
  def game_played_today
    agent = Mechanize.new
    agent.keep_alive = false
    page = agent.get(@match_history)
    result = page.search('.match_details')
    time_played = result.first.children[3].search('div')[3].text
    if time_played.include?("hours") || time_played.include?("minutes")
      return true
    end
    return false
  end
  
  # check if the most recent record is recorded
  # return true if the last game on lolking is the same as the recorded one
  # return false if there is a new game to record
  def check_if_recorded
    if File.exists?(get_record_name)
      contents = DateTime.parse(File.read(get_record_name))
      last_game = DateTime.now - (60 * get_last_game_time[0..2].to_i)
      times = [contents, last_game].sort
      if times[1] - times[0] < 900 
        return true
      end
    end
    return false
  end

  def game_played_in_last_hour
    agent = Mechanize.new
    agent.keep_alive = false
    page = agent.get(@match_history)
    result = page.search('.match_details')
    time_played = result.first.children[3].search('div')[3].text
    if  time_played.include?("minutes")
      return true
    end
    return false
  end

  def record_stats
    agent = Mechanize.new
    agent.keep_alive = false 
    start_time = Time.now
    page = agent.get(@match_history)
    result = page.search('.match_details')
    stats = []
    stats << result.children[1].search('a').first['href'][11..100]
    items_bought = result.first.children[15].search('a').size
    stats << result.first.children[15].search('a')[0]['href'][7..11] if items_bought >= 1
    stats << result.first.children[15].search('a')[1]['href'][7..11] if items_bought >= 2
    stats << result.first.children[15].search('a')[2]['href'][7..11] if items_bought >= 3
    stats << result.first.children[15].search('a')[3]['href'][7..11] if items_bought >= 4
    stats << result.first.children[15].search('a')[4]['href'][7..11] if items_bought >= 5
    stats << result.first.children[15].search('a')[5]['href'][7..11] if items_bought >= 6
    stats << result.children[7].search('strong')[0].text
    stats << result.children[7].search('strong')[1].text
    stats << result.children[7].search('strong')[2].text 
    stats << result.children[9].search('strong').text
    stats << result.children[11].search('strong').text
    filename = 'game_record' + @id.to_s
    m = File.open(filename, 'w')
    stats.each do |g|
      m.puts(g)
    end
  end
  
  # clear and save the record
  def clear_record
    if record_file_exists?
      f = File.open(get_record_name, 'rb')
      contents = f.read
      f.close
      
      f = File.open(get_record_name, 'w')
      num_min = get_last_game_time[0..2].to_i
      time_played = Time.now - (60 * num_min)
      f.puts(time_played.to_s)
      f.close
      
      return contents
    end
    return "nothing"
  end

  def print_last_game_champ_played
    agent = Mechanize.new
    agent.keep_alive = false
    page = agent.get(@match_history)
    result = page.search('.match_details')
    champ = result.first.children[1].search('a').first['href'][11..100]
    return champ
  end
  
  def record_file_exists?
    if File.exists?(get_record_name)
      return true
    end
    return false
  end
  
  def get_last_game_time  
    agent = Mechanize.new
    agent.keep_alive = false
    page = agent.get(@match_history)
    result = page.search('.match_details')
    time_played = result.first.children[3].search('div')[3].text
    return time_played 
  end
  
  def get_record_name
    filename = './game_record' + @id.to_s
    return filename
  end

  def get_match_history_link
    return @match_history
  end

  def get_log
    return @log
  end
end

