require_relative "../spread_reader"

describe SpreadReader do

  describe "#call" do
    context "when file doesn't exist" do
      it "raises FileNotFoundError error" do
        reader = SpreadReader.new("example.dat")

        expect {
          reader.call
        }.to raise_error(SpreadReader::FileNotFoundError)
      end
    end

    context "when file exists" do
      context "and block is given" do
        context "and block returns all required sources" do
          it "returns min spread" do
            reader = SpreadReader.new("spec/test.dat")

            spread = reader.call do |line|
              if matched_line = line.split(" ")
                {
                  label: matched_line[0],
                  max:   matched_line[1].to_i,
                  min:   matched_line[2].to_i,
                }
              end
            end

            expect(spread).to match_array(["b", 3])
          end
        end

        context "but a key is missing" do
          it "raises KeyMissingError" do
            reader = SpreadReader.new("spec/test.dat")

            expect {
              reader.call do |line|
                if matched_line = line.split(" ")
                  {
                    label: matched_line[0],
                    max: matched_line[1],
                  }
                end
              end
            }.to raise_error(
              SpreadReader::KeyMissingError,
              "Key 'min' is missing. The required keys are [:label, :max, :min]"
            )
          end
        end

        context "but the value of a key is nil" do
          it "raises NilValueError" do
            reader = SpreadReader.new("spec/test.dat")

            expect {
              reader.call do |line|
                matched_line = line.split(" ")
                if matched_line
                  {
                    label: line[0],
                    min:   nil,
                    max:   line[2],
                  }
                end
              end
            }.to raise_error(
              SpreadReader::NilValueError,
              "Value for 'min' cannot be nil."
            )
          end
        end

        context "but the block returns nil" do
          it "raises SourceMissingError" do
            reader = SpreadReader.new("spec/test.dat")

            expect {
              reader.call { nil }
            }.to raise_error(SpreadReader::SourceMissingError)
          end
        end
      end

      context "and the block is not given" do
        it "raises BlockMissingError" do
          expect {
            SpreadReader.new("spec/test.dat").call
          }.to raise_error(SpreadReader::BlockMissingError)
        end
      end
    end
  end
end
