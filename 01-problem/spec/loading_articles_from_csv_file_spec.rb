require 'spec_helper'
require_relative '../lib/articles'
require_relative './support/generate_doi'
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
    it "yields no articles" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "no_articles.csv"),
          double("Journals"),
          double("Authors")
      )

      expect(articles).to be_empty
    end
  end

  context "when the file contains 1 article" do
    before(:each) do
      doi = a_doi
      journal = a_journal
      author = an_author.of_publications(doi)
      @journals = some_journals(journal)
      @authors = some_authors(author)
      @expected_article = some_articles([doi, journal, author])
      write_to @article_csv, @expected_article.first
    end

    it "yields the article" do
      articles = Articles.load_from(
          @article_csv, @journals, @authors)

      expect(articles.all).to contain_exactly(@expected_article)
    end
  end

  context "when the file contains 2 articles" do
    before :each do
      journal_1, journal_2 = a_journal, a_journal
      @journals = some_journals(journal_1, journal_2)
      doi_1, doi_2 = a_doi, a_doi
      author_1, author_2 = [doi_1, doi_2].collect{|doi|
        an_author.of_publications(doi)
      }
      @authors = some_authors(author_1, author_2)
      @expected_articles = some_articles(
        [doi_1, journal_1, author_1],
        [doi_2, journal_2, author_2]
      )      
      write_to @article_csv, @expected_articles.first, @expected_articles.last
    end

    it "yields both articles" do
      articles = Articles.load_from(
        @article_csv, @journals, @authors)

      expect(articles.all).to contain_exactly(@expected_articles)
    end
  end

  context "when the file contains many articles" do
    before(:each) do
      journal_1, journal_2, journal_3 = a_journal, a_journal, a_journal
      @journals = some_journals(journal_1, journal_2, journal_3)
      doi_1, doi_2, doi_3 = a_doi, a_doi, a_doi
      author_1, author_2,author_3 = [doi_1, doi_2, doi_3].collect{ |doi|
        an_author.of_publications doi
      }
      @authors = some_authors(author_1, author_2, author_3)
      @expected_articles = some_articles(
        [doi_1, journal_1, author_1],
        [doi_2, journal_2, author_2],
        [doi_3, journal_3, author_3]
      )      
      write_to(@article_csv,
               @expected_articles.first,
               @expected_articles[1],
               @expected_articles.last)
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
      articles = Articles.load_from(
          @article_csv, @journals, @authors)

      expect(articles).to be_empty
    end
  end
end
