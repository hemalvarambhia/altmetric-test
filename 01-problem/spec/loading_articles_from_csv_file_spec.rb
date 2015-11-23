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
      articles = collection_of_articles

      expect(-> { articles.load_from('non_existent.csv') }).to(
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
      articles = collection_of_articles
       
      articles.load_from(@article_csv)

      expect(articles).to be_empty
    end
  end

  [1, 2, 3].each do |number_of|
    context "when the file contains #{number_of} article(s)" do
      before(:each) do
        @journals = journals(number_of)
        @authors = authors(number_of)
        @expected_articles = Articles.new(
          articles(@authors, @journals.first).first(number_of), 
          @journals, 
          @authors)
        write_to_file *@expected_articles
      end

      it 'yields every article' do
        articles = collection_of_articles
        
        articles.load_from(@article_csv)

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
      write_to_file(*articles)
    end

    it 'excludes those articles' do
      articles = collection_of_articles
      
      articles.load_from(@article_csv)

      expect(articles).to be_empty
    end
  end

  context 'when the file contains article with no authors' do
    before(:each) do
      @journals = journals(3)
      missing_author = an_author.build
      @authors = authors(3)
      write_to_file(
        *an_article_authored_by(missing_author, @journals.first)
      )
    end

    it 'excludes those articles' do
      articles = collection_of_articles

      articles.load_from(@article_csv)

      expect(articles).to be_empty
    end
  end

  context "when an article has multiple authors" do
    before :each do
      journal = a_journal.build
      @journals = Journals.new([journal])
      doi = a_doi
      @co_authors = co_authors_of(doi).map {|co_author| co_author.build }
      @authors = Authors.new(@co_authors)
      articles = article_co_authored_by(doi, @co_authors, journal)
      write_to_file(*articles)
    end

    it 'records all the authors of the article' do
      articles = collection_of_articles
    
      articles.load_from(@article_csv)

      article = articles.first
      expect(article.author).to(
        be == @co_authors.map { |author| author.name })
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
        actual.author == expected.author &&
        actual.journal_published_in.issn ==
        expected.journal_published_in.issn &&
        actual.journal_published_in.title ==
        expected.journal_published_in.title
    end
  end

  private

  def collection_of_articles
    Articles.new([], @journals, @authors)
  end

  def write_to_file(*articles)
    CSV.open(@article_csv, 'w') do |csv|
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

  def an_article_authored_by(author, journal)
    articles = 
      [
        an_article
        .with_doi(author.publications.sample)
        .authored_by(author)
        .published_in(journal).build
      ]
    articles
  end

  def article_co_authored_by(doi, co_authors, journal)
    [ 
      an_article.
      with_doi(doi).
      authored_by(*co_authors).
      published_in(journal).build
    ]
  end
end
