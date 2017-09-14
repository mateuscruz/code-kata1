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
                  max:   matched_line[1],
                  min:   matched_line[2],
                }
              end
            end

            expect(spread).to match_array(["b", 3])
          end
        end

        context "but a source is missing" do
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

        context "but an object that does not respond to :[] not returned" do
          xit "raises KeyMissingError" do
            reader = SpreadReader.new("spec/test.dat")

            expect {
              reader.call { nil }
            }.to raise_error(
              SpreadReader::KeyMissingError,
              "Key 'label' is missing. The required keys are [:label, :max, :min]"

            )
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
