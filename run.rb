require_relative "spread_reader"


regex = /\s+(?<label>\d+)\s+(?<max>\d+)\s+(?<min>\d+)/
min_spread = SpreadReader.new("weather.dat").call do |line|
  if matched_line = line.match(regex)
    {
      label: matched_line[:label],
      max: matched_line[:max],
      min: matched_line[:min],
    }
  else
    nil
  end
end

puts "#{min_spread[0]} #{min_spread[1]}"

regex = /\s+\d+\.\s(?<label>\w+)(.+?)(?<max>\d+)\s+\-\s+(?<min>\d+)/
min_spread = SpreadReader.new("football.dat").call do |line|
  if matched_line = line.match(regex)
    {
      label: matched_line[:label],
      max: matched_line[:max],
      min: matched_line[:min],
    }
  else
    nil
  end
end

puts "#{min_spread[0]} #{min_spread[1]}"
