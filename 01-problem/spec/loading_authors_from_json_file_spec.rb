require 'spec_helper'
require_relative '../lib/file_not_found'
require_relative '../lib/authors'
require_relative '../lib/doi'

describe 'Loading authors from a JSON file' do

  before(:each) do
    FileUtils.mkdir(fixtures_dir)
    @authors_file = File.join(fixtures_dir, 'authors.json')
  end

  after(:each) do 
    FileUtils.rm(@authors_file) if File.exists?(@authors_file)
    FileUtils.rm_r(File.join('spec', 'fixtures')) 
  end

  context 'when the file does not exist' do
    it 'raises an error' do
      expect(
        lambda { Authors.load_from('non_existent.json') }
      ).to raise_error(FileNotFound)
    end
  end

  context 'when the file has no authors' do
    it 'yields no authors' do
      write_authors_to @authors_file

      authors = Authors.load_from(@authors_file)

      expect(authors).to be_empty
    end
  end

  context 'when an author has no publications' do
    before :each do
      authors = authors an_author.with_no_publications
      write_authors_to @authors_file, *authors
    end

    it 'yields no authors' do
      authors = Authors.load_from(@authors_file)

      expect(authors).to be_empty
    end
  end

  [1, 2, 4].each do |number_of|
    context "when the file consists of #{number_of} author(s)" do
      context 'when the author(s) has/have 1 or more publications' do
        before :each do
          @expected_authors = authors(*Array.new(number_of) { an_author })
          write_authors_to @authors_file, *@expected_authors
        end

        it 'yields every author' do
          authors = Authors.load_from(@authors_file)

          expect(authors.size).to be == number_of
          expect(authors).to(eq(@expected_authors))
        end
      end
    end
  end

  def authors(*authors)
    Authors.new(authors.map { |author| author.build })
  end

  def write_authors_to(authors_file, *authors)
    File.delete(authors_file) if File.exist?(authors_file)
    authors_to_hash = authors.map do |author|
      {
        'name' => author.name,
        'articles' => author.publications
      }
    end

    File.open(authors_file, 'w') do |file|
      file.puts authors_to_hash.to_json
    end
  end

  matcher :eq do |expected|
    match do |authors|
      are_equal = true
      authors.each_with_index do |author, index|
        are_equal &&= are_equal?(expected[index], author)
      end

      return expected.size == authors.size && are_equal
    end

    def are_equal?(expected, actual)
      actual == expected
    end
  end
end
