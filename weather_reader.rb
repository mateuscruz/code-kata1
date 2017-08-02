class WeatherReader

  def initialize(path)
    @filepath = path
    @spreads = {}
  rescue => err
    err
  end

  def read
    regex = /\s+(?<day>\d+)\s+(?<max>\d+)\s+(?<min>\d+)/
    File.new(filepath, "r") do |file|
      while(line = file.gets)
        if(@matched_line = line.match(regex))
          store_spread
        end
      end
    end
  end

  def min_spread
    spreads.select { |key, value| value == spreads.values.min }.to_a.flatten
  end

  private

  def store_spread
    day = matched_line[:day]
    max = matched_line[:max].to_i
    min = matched_line[:min].to_i
    spreads[day] = (max - min).abs
  end

  attr_reader :filepath :spreads, :matched_line
end
