class SpreadReader

  REQUIRED_KEYS = [ :label, :max, :min ]

  SpreadReaderError    = Class.new(StandardError)
  FileNotFoundError    = Class.new(SpreadReaderError)
  BlockMissingError    = Class.new(SpreadReaderError)
  KeyMissingError      = Class.new(SpreadReaderError)
  InvalidObjectError   = Class.new(SpreadReaderError)
  NilValueError        = Class.new(SpreadReaderError)
  SourceMissingError   = Class.new(SpreadReaderError)

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

      validate(matched_line)

      if matched_line
        spreads[matched_line[:label]] =
          (matched_line[:max] - matched_line[:min]).abs
      end
    end
  end

  def filter_min_spread
    spreads.min { |(_, min1), (_, min2)| min1 <=> min2 }
  end

  private

  attr_reader :filepath, :spreads, :content

  def validate(matched_line)
    validate_source(matched_line)
    validate_keys(matched_line)
    validate_values(matched_line)
  end

  def validate_source(matched_line)
    raise SourceMissingError unless matched_line
  end

  def validate_keys(matched_line)
    missing_keys = REQUIRED_KEYS - matched_line.keys
    missing_keys.any?
      raise KeyMissingError.new(
        "Key '#{missing_keys.first}' is missing. The required keys are #{REQUIRED_KEYS}"
      )
  end

  def validate_values(matched_line)
    matched_line.each do |key, value|
      raise NilValueError.new("Value for '#{key}' cannot be nil.") unless value
    end
  end

  def read_content
    @content = File.read(filepath)
  rescue Errno::ENOENT
    raise FileNotFoundError.new("File #{filepath} does not exist.")
  end

end
