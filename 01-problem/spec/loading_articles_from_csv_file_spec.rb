require 'spec_helper'
require_relative '../lib/articles'
describe 'Loading articles from a CSV file' do
  include GenerateDOI

  before(:each) do
    FileUtils.mkdir(fixtures_dir)
    @article_csv = File.join(fixtures_dir, 'articles.csv')
  end

  after(:each) do 
    FileUtils.rm(@article_csv) if File.exists?(@article_csv)
    FileUtils.rm_r(fixtures_dir)
  end

  context 'when the file does not exist' do
    it 'raises an error' do
      @journals = Journals.new
      @authors = Authors.new
      
      expect(-> { load_articles }).to(
        raise_error(FileNotFound))
    end
  end

  context 'when the file has no articles (just headers)' do
    before :each do
      write_to_file
    end

    it 'yields no articles' do
      @journals = Journals.new
      @authors = Authors.new
       
      articles = load_articles

      expect(articles).to be_empty
    end
  end

  [1, 2, 3].each do |number_of|
    context "when the file contains #{number_of} article(s)" do
      before(:each) do
        @journals = journals(number_of)
        @authors = authors(number_of)
        @expected_articles =
           generate_articles_from(@authors, @journals).first(number_of)
        write_to_file *@expected_articles
      end

      it 'yields every article' do
        articles = load_articles

        expect(articles.size).to be == number_of
        expect(articles).to eq(@expected_articles)
      end
    end
  end

  context 'when the file contains articles published in unknown journals' do
    before :each do
      @journals = journals(3)
      @authors = authors(3)
      unknown_journal = a_journal.build
      write_to_file(*articles_authored_by(@authors, unknown_journal))
    end

    it 'excludes those articles' do
      articles = load_articles

      expect(articles).to be_empty
    end
  end

  context 'when the file contains articles by unknown authors' do
    before(:each) do
      @journals = journals(3)
      @authors = authors(3)
      unknown_author = an_author.build
      write_to_file(
        *an_article_authored_by(unknown_author, @journals.first)
      )
    end

    it 'excludes those articles' do
      articles = load_articles

      expect(articles).to be_empty
    end
  end

  context "when an article has multiple authors" do
    before :each do
      @journals = journals(3)
      doi = a_doi
      @co_authors = co_authors_of(doi)
      @authors = Authors.new(@co_authors)
      write_to_file(
        article_co_authored_by(doi, @co_authors, @journals.first)
      )
    end

    it 'records all the authors of the article' do
      articles = load_articles

      article = articles.first
      expect(article.authors).to be == @co_authors
    end
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
        actual.authors == expected.authors &&
        actual.journal_published_in.issn ==
        expected.journal_published_in.issn &&
        actual.journal_published_in.title ==
        expected.journal_published_in.title
    end
  end

  private

  def load_articles
    articles = Articles.new([],  @journals, @authors)
    articles.load_from(@article_csv)
    articles
  end

  def write_to_file(*articles)
    CSV.open(@article_csv, 'w') do |csv|
      csv << %w(DOI Title Author Journal ISSN)
      articles.each do |article|
        csv << [
          article.doi,
          article.title,
          article.authors.map{|author| author.name }.join(', '),
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

  def articles_authored_by(authors, journal)
    authors.map do |author|
      author.publications.map do |doi|
        an_article.
          with_doi(doi).
          authored_by(author).
          published_in(journal).
          build

      end
    end.flatten
  end

  def generate_articles_from(authors, journals)
     journals.map do |journal| 
       articles_authored_by(authors, journal) 
     end.flatten
  end

  def an_article_authored_by(author, journal)
    an_article.
    with_doi(author.publications.sample).
    authored_by(author).
    published_in(journal).build
  end

  def article_co_authored_by(doi, co_authors, journal)
    an_article.
    with_doi(doi).
    authored_by(*co_authors).
    published_in(journal).build
  end
end
