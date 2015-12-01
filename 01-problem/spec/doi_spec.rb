require_relative '../lib/doi'

describe 'Digital object identifiers' do
  describe 'a blank DOI' do
    it 'is invalid' do
      expect(lambda { DOI.new('') }).to raise_error DOI::Malformed
      expect(lambda { DOI.new(nil) }).to raise_error DOI::Malformed
    end
  end

  describe 'a DOI that does not start with 10' do
    it 'is not valid' do
      expect(lambda { DOI.new('90') }).to raise_error(DOI::Malformed)
    end
  end

  describe 'a DOI that has a valid prefix and no suffix' do
    it 'is invalid' do
      expect(lambda { DOI.new('10.1234') }).to raise_error(DOI::Malformed)
      expect(lambda { DOI.new('10.1234/') }).to raise_error(DOI::Malformed)
      expect(lambda { DOI.new('10.1234/ ') }).to raise_error(DOI::Malformed)
    end
  end

  describe 'a DOI that has a prefix and suffix' do
    context 'prefix has no registrant code' do
      it 'is invalid' do
        expect(lambda { DOI.new('10/altmetric121') }).to raise_error(DOI::Malformed)
        expect(lambda { DOI.new('10./altmetric121') })
          .to raise_error(DOI::Malformed)
      end
    end

    context 'prefix is not separated by a full-stop' do
      it 'is invalid' do
        expect(lambda { DOI.new('10,1234/altmetric098') })
          .to raise_error(DOI::Malformed)
      end
    end

    context 'both are correctly specified' do
      it 'is valid' do
        expect(lambda { DOI.new('10.1234/altmetric345') }).not_to raise_error
        expect(lambda { DOI.new(' 10.1234 / altmetric421 ') })
          .not_to raise_error
        expect(lambda { DOI.new('10. 1234/altmetric876') }).not_to raise_error
      end
    end
  end

  describe 'equating DOIs' do
    it 'is reflexive' do
      doi = DOI.new('10.1234/altmetric543')
      expect(doi).to eq(doi)
    end

    it 'is transitive' do
      doi_1 = DOI.new('10.1234/altmetric132')
      doi_2 = DOI.new('10.1234/altmetric132')
      doi_3 = DOI.new('10.1234/altmetric132')

      expect(doi_1).to eq(doi_2)
      expect(doi_2).to eq(doi_3)
      expect(doi_1).to eq(doi_3)
    end

    it 'is symmetric' do
      doi_1 = DOI.new('10.1234/altmetric965')
      doi_2 = DOI.new('10.1234/altmetric965')

      expect(doi_1).to eq(doi_2)
      expect(doi_2).to eq(doi_1)
    end

    it 'is case-insensitive' do
      doi_1 = DOI.new('10.1234/altmetric965')
      doi_2 = DOI.new('10.1234/ALTMETRIC965')

      expect(doi_1).to eq(doi_2)
    end

    context 'different DOIs' do
      it 'confirms them as not being equal' do
        doi = DOI.new('10.1234/altmetric675')
        different_doi = DOI.new('10.6543/altmetric875')

        expect(doi).not_to eq(different_doi)
      end
    end
  end
end
