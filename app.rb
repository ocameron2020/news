 require "sinatra"
 require "sinatra/reloader"
 require "httparty"
 def view(template); erb template.to_sym; end


get "/" do
## Get the weather
## Lat and Long of Barton, Vermont
    lat = 44.752011
    long = -72.171659

### Weather API
    units = "imperial" 
    key = "ecc22875ce740e49b4ed25f48ab8c9b4" 
    url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

### The Weather
    @forecast = HTTParty.get(url).parsed_response.to_hash
    @current = ["#{@forecast["current"]["temp"]} degrees" " " "and" " " "#{@forecast["current"]["weather"][0]["description"]} conditions"] 
    puts @current
    puts "The Weekly Outlook:"
    outlook = []
    day_number = 1
        for day in @forecast["daily"]
            outlook << "#{day_number} days from now it will be #{day["weather"][0]["description"]} conditions, with a high of #{day["temp"]["max"]} degrees and a low of #{day["temp"]["min"]} degrees"
            day_number = day_number + 1
        end
    @fwdoutlook = outlook[0, 7]
 
### News API
    newskey = "97f6a549bb974f8093eeec7463595200"
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=#{newskey}"
    @news = HTTParty.get(url).parsed_response.to_hash

### The News
    news = []
    article_number = 1
    for article in @news["articles"]
        # news << "#{article["url"]}>#{article["title"]}" 
        news << "#{article["url"]}>#{article["source"]["name"]}" " " "|" " " "#{article["title"]}"
        article_number = article_number + 1
    end
    @topnews = news[0,10]
    
    view "news"

  end

  

