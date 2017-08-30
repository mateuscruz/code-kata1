require_relative "../spread_reader"

describe SpreadReader do
  subject { described_class }

  describe "#call" do
    context "when file doesn't exist" do
      it "raises Errno::ENOENT error" do
        expect{
          subject.new("example.dat").call { |line| line }
        }.to raise_error(Errno::ENOENT)
      end
    end

    context "when file exists" do
      context "and the information source is given" do
        it "returns min spread" do
          # pensar numa forma mais clara de escrever este teste
          source = /(?<label>[a-zA-Z]+)\s+(?<max>\d+)\s+(?<min>\d+)/

          expect(
            subject.new("spec/test.dat").call do |line|
              if matched_line = line.match(source)
                {
                  label: matched_line[:label],
                  max:   matched_line[:max],
                  min:   matched_line[:min],
                }
              end
            end
          ).to match_array(["b", 3])
        end
      end

      # faltou testar quando algum parametro esta faltando

      context "and the information source is not given" do
        it "raises argument error" do
          expect { subject.new("spec/test.dat").call }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
