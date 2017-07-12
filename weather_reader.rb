class WeatherReader

  def initialize(path)
    @file = File.new(path, "r")
    @spreads = {}
  rescue => err
    err
  end

  def close
    file.close
  end

  def read
    regex = /\s+(?<day>\d+)\s+(?<max>\d+)\s+(?<min>\d+)/
    while(line = file.gets)
      if(@matched_line = line.match(regex))
        store_spread
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

  attr_reader :file
  attr_reader :spreads
  attr_reader :matched_line
end
