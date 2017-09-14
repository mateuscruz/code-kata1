class SpreadReader

  REQUIRED_KEYS = [ :label, :max, :min ]

  FileNotFoundError    = Class.new(StandardError)
  BlockMissingError    = Class.new(StandardError)
  KeyMissingError      = Class.new(StandardError)
  InvalidObjectError   = Class.new(StandardError)

  def initialize(path)
    @filepath = path
    @spreads = {}
  end

  def call(&block)
    read_content
    raise BlockMissingError.new("Function 'call' requires a block.") unless block_given?
    map_day_to_spread(&block)
    filter_min_spread
  end

  def map_day_to_spread(&block)
    content.split("\n").each do |line|
      matched_line = block.call(line)

      validate_keys(matched_line)

      if matched_line
        spreads[matched_line[:label]] =
          (matched_line[:max].to_i - matched_line[:min].to_i).abs
      end
    end
  end

  def filter_min_spread
    spreads.min { |(_, min1), (_, min2)| min1 <=> min2 }
  end

  private

  attr_reader :filepath, :spreads, :content

  def validate_keys(matched_line)
    REQUIRED_KEYS.each do |label|
      # Preciso tratar isso de um jeito mais resiliente
      unless matched_line.has_key?(label)
        raise KeyMissingError.new(
          "Key '#{label}' is missing. The required keys are #{REQUIRED_KEYS}"
        )
      end
    end
  end

  def read_content
    @content = File.read(filepath)
  rescue Errno::ENOENT
    raise FileNotFoundError.new("File #{filepath} does not exist.")
  end

end
