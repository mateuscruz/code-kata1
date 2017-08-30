class SpreadReader

  def initialize(path)
    @filepath = path
    @spreads = {}
  end

  def call(block = Proc.new)
    read_content
      .map_day_to_spread(block)
      .filter_min_spread
  end

  def map_day_to_spread(block = Proc.new)
    content.split("\n").each do |line|
      matched_line = block.call(line)
      if matched_line
        spreads[matched_line[:label]] =
          (matched_line[:max].to_i - matched_line[:min].to_i).abs
      end
    end
    self
  end

  def filter_min_spread
    spreads.min { |(_, min1), (_, min2)| min1 <=> min2 }
  end

  private

  attr_reader :filepath, :spreads, :content

  def read_content
    @content = File.read(filepath)
    self
  end

end
