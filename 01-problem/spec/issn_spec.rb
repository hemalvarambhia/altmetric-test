require_relative '../lib/issn'
describe 'ISSNs' do
  describe 'a blank ISSN' do
    it 'is invalid' do
      expect(lambda { ISSN.new('') }).to raise_error(InvalidISSN)
      expect(lambda { ISSN.new(nil) }).to raise_error(InvalidISSN)
    end
  end

  describe 'an ISSN with fewer than 8 digits' do
    it 'is invalid' do
      expect(lambda { ISSN.new('1234-56') }).to raise_error(InvalidISSN)
      expect(lambda { ISSN.new('1514') }).to raise_error(InvalidISSN)
    end
  end

  describe 'an ISSN with more than 8 digits' do
    it 'is invalid' do
      expect(lambda { ISSN.new('43565-32932') }).to raise_error(InvalidISSN)
    end
  end

  describe 'a well-formed ISSN with 8-digits' do
    it 'is valid' do
      expect(lambda { ISSN.new('0378-5955') }).not_to raise_error
      expect(lambda { ISSN.new(' 0378-5955 ') }).not_to raise_error
    end

    it 'has only one hash at the 4th position' do
      expect(ISSN.new('0378-5955').to_s).to eq('0378-5955')
    end
  end

  describe 'an ISSN with the dash in the wrong position' do
    it 'is invalid' do
      expect(lambda { ISSN.new('037-85955') }).to raise_error(InvalidISSN)
    end
  end

  describe 'an 8-digit ISSN without the dash' do
    it 'is valid' do
      expect(lambda { ISSN.new('03785955') }).not_to raise_error
    end

    it 'includes the dash at instanciation' do
      expect(ISSN.new('03785955').to_s).to eq('0378-5955')
    end
  end

  describe 'an ISSN with only letter characters' do
    it 'is invalid' do
      expect(lambda { ISSN.new('aybc-riet') }).to raise_error(InvalidISSN)
    end
  end

  describe 'equating ISSN' do
    it 'is reflexive' do
      issn = ISSN.new('0024-9319')

      expect(issn).to eq(issn)
    end

    it 'is transitive' do
      issn_1 = ISSN.new('0024-9319')
      issn_2 = ISSN.new('0024-9319')
      issn_3 = ISSN.new('0024-9319')

      expect(issn_1).to eq(issn_2)
      expect(issn_2).to eq(issn_3)
      expect(issn_1).to eq(issn_3)
    end

    it 'is symmetric' do
      issn_1 = ISSN.new('0024-9319')
      issn_2 = ISSN.new('0024-9319')

      expect(issn_1).to eq(issn_2)
      expect(issn_2).to eq(issn_1)
    end

    context 'same DOIs, one with dash and one without' do
      it 'confirms them to be the same' do
        issn_with_dash = ISSN.new('0024-9319')
        same_issn_without_dash = ISSN.new('0024-9319')

        expect(issn_with_dash).to eq(same_issn_without_dash)
      end
    end
  end
end
