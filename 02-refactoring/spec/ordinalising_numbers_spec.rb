require 'fixnum'
describe Fixnum do
  describe 'ordinalising numbers' do
    context 'when it is the number 1' do
      it 'returns 1st' do
        expect(1.ordinalize).to eq('1st')
      end
    end

    context 'when it is the number 2' do
      it 'returns 2nd' do
        expect(2.ordinalize).to eq('2nd')
      end
    end

    context 'when it is the number 3' do
      it 'returns 3rd' do
        expect(3.ordinalize).to eq('3rd')
      end
    end
 
    (4..10).each do |number|
      context "when it is the number #{number}" do
        it "returns #{number}th" do
          expect(number.ordinalize).to eq("#{number}th")
        end
      end
    end
  end
end