require_relative "weather_reader"

reader = WeatherReader.new("weather.dat")
reader.read
min_spread = reader.min_spread
puts "#{min_spread[0]} #{min_spread[1]}"
