require_relative '../lib/author'
require_relative '../lib/doi'

describe 'Equating Authors' do
  it 'is reflexive' do
    author = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')])

    expect(author).to eq(author)
  end

  it 'is transitive' do
    author_1 = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')])
    author_2 = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')]
    )
    author_3 = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')]
    )

    expect(author_1).to eq(author_2)
    expect(author_2).to eq(author_3)
    expect(author_1).to eq(author_3)
  end

  it 'is symmetric' do
    author_1 = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')])
    author_2 = AcademicResearch::Author.new(
        'Author', [DOI.new('10.1234/altmetric007')]
    )

    expect(author_1).to eq author_2
    expect(author_2).to eq author_2
  end

  context 'authors with a different names but same publications' do
    it 'confirms them as not being the same' do
      author = AcademicResearch::Author.new(
          'Author', [DOI.new('10.1234/altmetric007')])
      collaborator = AcademicResearch::Author.new(
          'Collaborator', [DOI.new('10.1234/altmetric007')]
      )

      expect(author).to_not eq(collaborator)
    end
  end

  context 'authors with the same name but different publications' do
    it 'confirms them as not being the same' do
      author = AcademicResearch::Author.new(
          'Jonathan Davis', [DOI.new('10.1234/altmetric127')])
      different_author_same_name = AcademicResearch::Author.new(
          'Jonathan Davis', [DOI.new('10.1234/altmetric489')]
      )

      expect(author).to_not eq(different_author_same_name)
    end
  end

end
