require 'spec_helper'
require_relative '../lib/articles'
describe 'Loading articles from a CSV file' do
  include GenerateDOI

  before(:each) do
    @article_csv = File.join(fixtures_dir, 'articles.csv')
  end

  context 'when the file does not exist' do
    it 'raises an error' do
      journals = double('Journals')
      author_publications = double('Authors')
      expect(lambda do
               Articles.load_from(
                 'non_existent.csv',
                 journals,
                 author_publications)
             end
            ).to raise_error(FileNotFound)
    end
  end

  context 'when the file has no articles (just headers)' do
    before :each do
      write_to @article_csv
    end

    it 'yields no articles' do
      articles = Articles.load_from(@article_csv, Journals.new, Articles.new)

      expect(articles).to be_empty
    end
  end

  [1, 2, 3].each do |number_of|
    context "when the file contains #{number_of} article(s)" do
      before(:each) do
        @journals = journals(number_of)
        @authors = authors(number_of)
        @expected_articles = articles(@authors, @journals.first)
                             .first(number_of)
        write_to @article_csv, *@expected_articles
      end

      it 'yields every article' do
        articles = Articles.load_from(@article_csv, @journals, @authors)

        expect(articles.size).to be == number_of
        expect(articles).to eq(@expected_articles)
      end
    end
  end

  context 'when the file contains articles with missing journals' do
    before :each do
      @journals = journals(3)
      missing_journal = a_journal.build
      @authors = authors(3)
      articles = articles(@authors, missing_journal)
      write_to(@article_csv, *articles)
    end

    it 'does not include those articles' do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end

  context 'when the file contains article with no authors' do
    before(:each) do
      @journals = journals(3)
      doi = a_doi
      missing_author = an_author.who_published(doi).build
      @authors = authors(3)
      write_to(
        @article_csv,
        *an_article_authored_by(missing_author, @journals.first)
      )
    end

    it 'excludes those articles' do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end

  context "when an article has multiple authors" do
    it "gathers all the authors in the loaded article"
  end

  matcher :eq do |expected|
    match do |articles|
      are_equal = true
      articles.each_with_index do |article, index|
        are_equal &&= are_equal?(expected[index], article)
      end

      return expected.size == articles.size && are_equal
    end

    def are_equal?(expected, actual)
      actual.doi == expected.doi &&
        actual.title == expected.title &&
        actual.author == expected.author &&
        actual.journal_published_in.issn ==
        expected.journal_published_in.issn &&
        actual.journal_published_in.title ==
        expected.journal_published_in.title
    end
  end

  private

  def write_to(file, *articles)
    File.delete(file) if File.exist?(file)

    CSV.open(file, 'w') do |csv|
      csv << %w(DOI Title Author Journal ISSN)
      articles.each do |article|
        csv << [
          article.doi,
          article.title,
          article.author.join(', '),
          article.journal_published_in.title,
          article.journal_published_in.issn
        ]
      end
    end
  end

  def journals(number)
    Journals.new(Array.new(number) { a_journal.build })
  end

  def authors(number)
    Authors.new(Array.new(number) { an_author.build })
  end

  def articles(authors, journal)
    Articles.new(
        authors.map do |author|
          author.publications.map do |doi|
            an_article
              .with_doi(doi)
              .authored_by(author)
              .published_in(journal).build
          end
        end.flatten
    )
  end

  def an_article_authored_by(author, journal)
    Articles.new(
      [
        an_article
        .with_doi(author.publications.sample)
        .authored_by(author)
        .published_in(journal).build
      ]
    )
  end
end
