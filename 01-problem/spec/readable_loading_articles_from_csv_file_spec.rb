require 'spec_helper'
require_relative '../lib/doi'
require_relative '../lib/journals'
require_relative '../lib/authors'
require_relative '../lib/author'
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
      @expected_article = [
        an_article.with_doi(doi).authored_by(author).published_in(journal)
      ].collect{|article| article.build}
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
      journal = a_journal
      another_journal = a_journal
      @journals = some_journals(journal, another_journal)
      doi = a_doi
      another_doi = a_doi
      author = an_author.of_publications(doi)
      another_author = an_author.of_publications(another_doi)
      @authors = some_authors(author, another_author)
      @expected_articles = [
        [journal, author],
        [another_journal, another_author]
      ].collect do |journal, author|
        an_article.with_doi(doi).authored_by(author).published_in(journal)
      end.collect{|article| article.build}
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
      @journals = Journals.new(
      [
        Journal.new(ISSN.new("0378-5955"), "Shanahan, Green and Ziemann"),
        Journal.new(ISSN.new("0024-9319"), "Wilkinson, Gaylord and Gerlach"),
        Journal.new(ISSN.new("0032-1478"), "Hahn and Sons")
      ])

      @authors = Authors.new(
          [
              Author.new("Amari Lubowitz", [DOI.new("10.1234/altmetric0")]),
              Author.new("Lenny Kshlerin", [DOI.new("10.1234/altmetric100")]),
              Author.new("Howard Spinka Jr.", [DOI.new("10.1234/altmetric103")])
          ])
    end
    
    it "yields every article" do
       articles = Articles.load_from(
        File.join(fixtures_dir, "many_articles.csv"),
        @journals,
        @authors
      ).all

       article = articles.first
       expect(article.doi).to eq("10.1234/altmetric0")
       expect(article.title).to eq("Small Wooden Chair")
       expect(article.author).to eq(["Amari Lubowitz"])
       expect(article.journal_published_in.title).to(
         eq("Shanahan, Green and Ziemann"))

       expect(article.journal_published_in.issn).to eq("0378-5955")

       article = articles[1]
       expect(article.doi).to eq("10.1234/altmetric100")
       expect(article.title).to eq("Ergonomic Rubber Shirt")
       expect(article.author).to eq(["Lenny Kshlerin"])
       expect(article.journal_published_in.title).to(
         eq("Wilkinson, Gaylord and Gerlach"))
       expect(article.journal_published_in.issn).to eq("0024-9319")

       article = articles.last
       expect(article.doi).to eq("10.1234/altmetric103")
       expect(article.title).to eq("Fantastic Granite Computer")
       expect(article.author).to eq(["Howard Spinka Jr."])
       expect(article.journal_published_in.title).to(
         eq("Hahn and Sons"))
       expect(article.journal_published_in.issn).to eq("0032-1478")
    end
  end

  context "when the file contains articles with missing journals" do
    before :each do
      @journals = Journals.new([])
      @authors = Authors.new(
          [
              Author.new("Author", [DOI.new("10.1234/altmetric156")])
          ]
      )
    end

    it "does not include those articles" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "articles_with_journals_missing.csv"),
          @journals,
          @authors
      )

      expect(articles).to be_empty
    end
  end

  context "when the file contains article with no authors" do
    before(:each) do
       @journals = Journals.new(
      [
        Journal.new(ISSN.new("0032-1478"), "Shanahan, Green and Ziemann")
      ])

      @authors = Authors.new(
          [
              Author.new("Amari Lubowitz", [DOI.new("10.1234/altmetric0")])
          ])
    end

    it "excludes those articles" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "articles_with_no_authors.csv"),
          @journals,
          @authors
      )

      expect(articles).to be_empty
    end
  end
end
