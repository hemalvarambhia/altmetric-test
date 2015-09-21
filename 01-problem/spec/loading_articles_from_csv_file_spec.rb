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

  context "when the file contains 1 article" do
    before(:each) do
      dois = Array.new(1){a_doi}
      journals = Array.new(1){a_journal}
      authors = dois.collect{|doi| an_author.of_publications doi }
      @journals = some_journals(*journals)
      @authors = some_authors(*authors)
      @expected_article = some_articles(
      	[dois.first, journals.first, authors.first]
      )
      write_to @article_csv, @expected_article.first
    end

    it "yields the article" do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles.all).to contain_exactly(@expected_article)
    end
  end

  context "when the file contains 2 articles" do
    before :each do
      journals = Array.new(2){a_journal}
      @journals = some_journals(*journals)
      dois = Array.new(2){a_doi}
      authors = dois.collect{|doi| an_author.of_publications doi}
      @authors = some_authors(*authors)
      @expected_articles = some_articles(
        [dois.first, journals.first, authors.first],
        [dois.last, journals.last, authors.last]
      )      
      write_to @article_csv, *@expected_articles
    end

    it "yields both articles" do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles.all).to contain_exactly(@expected_articles)
    end
  end

  context "when the file contains many articles" do
    before(:each) do
      journals = Array.new(3){a_journal}
      @journals = some_journals(*journals)
      dois = Array.new(3){a_doi}
      authors = dois.collect{ |doi| an_author.of_publications doi }
      @authors = some_authors(*authors)
      @expected_articles = some_articles(
        [dois.first, journals.first, authors.first],
        [dois[1], journals[1], authors[1]],
        [dois.last, journals.last, authors.last]
      )      
      write_to(@article_csv, *@expected_articles)
    end
    
    it "yields every article" do
      articles = Articles.load_from(@article_csv, @journals, @authors).all

      expect(articles).to contain_exactly @expected_articles
    end
  end
  
  context "when the file contains articles with missing journals" do
    before :each do
      missing_journal = a_journal
      @journals = some_journals(a_journal, a_journal)
      doi = a_doi
      author = an_author.of_publications doi
      @authors = some_authors(author)
      write_to(
        @article_csv, some_articles([doi, missing_journal, author]).first)
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
        @article_csv, some_articles([doi, journal, missing_author]).first)
    end

    it "excludes those articles" do
      articles = Articles.load_from(@article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end
end
