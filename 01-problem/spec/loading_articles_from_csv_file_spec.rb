require 'spec_helper'
require_relative '../lib/articles'
describe "Loading articles from a CSV file" do
  include GenerateDOI

  before(:each) do
    @article_csv = File.join(fixtures_dir, "articles.csv")
  end
  
  context "when the file does not exist" do
    it "raises an error" do
      journals = double("Journals")
      author_publications = double("Authors")
      expect(lambda {Articles.load_from(
                 "non_existent.csv",
                 journals,
                 author_publications)}).to raise_error(FileNotFound)
    end
  end

  context "when the file has no articles (just headers)" do
    before :each do
      write_to @article_csv
    end
    
    it "yields no articles" do
      articles = Articles.load_from(@article_csv, some_journals, some_authors)

      expect(articles).to be_empty
    end
  end

[1, 2, 3].each do |number_of|
  context "when the file contains #{number_of} article(s)" do
    before(:each) do
      @journals = Array.new(number_of){a_journal}
      dois = Array.new(number_of){a_doi}
      @authors = authors_of dois
      @expected_articles = some_articles(dois)
      write_to @article_csv, *@expected_articles
    end

    it "yields every article" do
      articles = Articles.load_from(
          @article_csv, some_journals(*@journals), some_authors(*@authors))

      expect(articles).to eq(@expected_articles)
    end
  end
end
  
  context "when the file contains articles with missing journals" do
    before :each do
      @journals = some_journals(a_journal, a_journal)
      missing_journal = a_journal
      doi = a_doi
      article_authors = authors_of([doi])
      @authors = some_authors *article_authors
      write_to(
        @article_csv,
        an_article.with_doi(doi).authored_by(*article_authors).published_in(missing_journal).build
      )
    end

    it "does not include those articles" do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end

  context "when the file contains article with no authors" do
    before(:each) do
      journal = a_journal
      @journals = some_journals journal
      doi = a_doi
      missing_author = an_author.of_publications(doi)
      @authors = some_authors(an_author, an_author)
      write_to(
        @article_csv,
        an_article.with_doi(doi).authored_by(missing_author).published_in(journal).build
      )
    end

    it "excludes those articles" do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end

  matcher :eq do |expected|
    match do |articles|
      are_equal = true
      articles.each_with_index do |article, index|
        are_equal = are_equal && are_equal?(expected[index], article)
      end

      return expected.size == articles.size && are_equal
    end

    def are_equal?(expected, actual)
      actual.doi == expected.doi &&
          actual.title == expected.title &&
          actual.author == expected.author &&
          actual.journal_published_in.issn == expected.journal_published_in.issn &&
          actual.journal_published_in.title == expected.journal_published_in.title
    end
  end

  private

  def write_to(file, *articles)
    File.delete(file) if File.exists?(file)
    CSV.open(file, "w") do |csv|
      csv << ["DOI", "Title", "Author", "Journal", "ISSN"]
      articles.each do |article|
        csv << [
            article.doi,
            article.title,
            article.author.join(", "),
            article.journal_published_in.title,
            article.journal_published_in.issn
        ]
      end
    end
  end

  def some_articles dois
    article_data = dois.zip(@journals, @authors)
    Articles.new(
        article_data.collect { |doi, journal, author|
          an_article.with_doi(doi).authored_by(author).published_in(journal)
        }.collect{|article| article.build}
    )
  end

  def authors_of publications
    Array.new(publications.size){|index| an_author.of_publications publications[index] }
  end
end
