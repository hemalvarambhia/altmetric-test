require 'spec_helper'
require_relative '../lib/doi'
require_relative '../lib/journals'
require_relative '../lib/authors'
require_relative '../lib/author'
require_relative '../lib/articles'

describe "Loading articles from a CSV file" do
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
      @journals = Journals.new(
          [
              Journal.new(
                  ISSN.new("1337-8688"), "Shanahan, Green and Ziemann")
          ]
      )

      @authors = Authors.new(
          [
              Author.new(
                  "Amari Lubowitz", [DOI.new("10.1234/altmetric0")])
          ]
      )
    end

    it "yields the article" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "one_article.csv"),
          @journals,
          @authors
      )

      article = articles.first
      expect(article.doi).to eq(DOI.new("10.1234/altmetric0"))
      expect(article.title).to eq("Small Wooden Chair")
      expect(article.author).to eq(["Amari Lubowitz"])
      expect(article.journal_published_in).to(
          eq(Journal.new(
                 ISSN.new("1337-8688"), "Shanahan, Green and Ziemann")))

    end
  end

  context "when the file contains 2 articles" do
    before :each do
      @journals = Journals.new(
          [
              Journal.new(
                  ISSN.new("1337-8688"), "Shanahan, Green and Ziemann"
              ),
              Journal.new(
                  ISSN.new("2542-5856"), "Wilkinson, Gaylord and Gerlach"
              )
          ])

      @authors = Authors.new(
          [
              Author.new(
                  "Amari Lubowitz", [DOI.new("10.1234/altmetric0")]
              ),
              Author.new(
                  "Lenny Kshlerin", [DOI.new("10.1234/altmetric100")]
              ),
          ])
    end

    it "yields both articles" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "two_articles.csv"),
          @journals,
          @authors
      )

      article = articles.first
      expect(article.doi).to eq(DOI.new("10.1234/altmetric0"))
      expect(article.title).to eq("Small Wooden Chair")
      expect(article.author).to eq(["Amari Lubowitz"])
      expect(article.journal_published_in).to(
          eq(Journal.new(
                 ISSN.new("1337-8688"), "Shanahan, Green and Ziemann"
             )))

      article = articles.last
      expect(article.doi).to eq(DOI.new("10.1234/altmetric100"))
      expect(article.title).to eq("Ergonomic Rubber Shirt")
      expect(article.author).to eq(["Lenny Kshlerin"])
      expect(article.journal_published_in).to(
          eq(Journal.new(
                 ISSN.new("2542-5856"), "Wilkinson, Gaylord and Gerlach"
             )))
    end
  end

  context "when the file contains many articles" do
    before(:each) do
      @journals = Journals.new(
          [
              Journal.new(ISSN.new("1337-8688"), "Shanahan, Green and Ziemann"),
              Journal.new(ISSN.new("2542-5856"), "Wilkinson, Gaylord and Gerlach"),
              Journal.new(ISSN.new("3775-0307"), "Hahn and Sons")
          ])

      @authors = Authors.new(
          [
              Author.new("Amari Lubowitz", [DOI.new("10.1234/altmetric0")]),
              Author.new("Lenny Kshlerin", [DOI.new("10.1234/altmetric100")]),
              Author.new("Howard Spinka Jr.", [DOI.new("10.1234/altmetric103")])
          ])
    end

    it "yields every articles" do
      articles = Articles.load_from(
          File.join(fixtures_dir, "many_articles.csv"),
          @journals,
          @authors
      ).all

      article = articles.first
      expect(article.doi).to eq(DOI.new("10.1234/altmetric0"))
      expect(article.title).to eq("Small Wooden Chair")
      expect(article.author).to eq(["Amari Lubowitz"])
      expect(article.journal_published_in).to(
          eq(Journal.new(ISSN.new("1337-8688"), "Shanahan, Green and Ziemann")))

      article = articles[1]
      expect(article.doi).to eq(DOI.new("10.1234/altmetric100"))
      expect(article.title).to eq("Ergonomic Rubber Shirt")
      expect(article.author).to eq(["Lenny Kshlerin"])
      expect(article.journal_published_in).to(
          eq(Journal.new(ISSN.new("2542-5856"), "Wilkinson, Gaylord and Gerlach")))


      article = articles.last
      expect(article.doi).to eq(DOI.new("10.1234/altmetric103"))
      expect(article.title).to eq("Fantastic Granite Computer")
      expect(article.author).to eq(["Howard Spinka Jr."])
      expect(article.journal_published_in).to(
          eq(Journal.new(ISSN.new("3775-0307"), "Hahn and Sons")))
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
              Journal.new(ISSN.new("1337-8688"), "Shanahan, Green and Ziemann")
          ])

      @authors = Authors.new(
          [
              Author.new("Amari Lubowitz", [DOI.new("10.1234/altmetric0")]
              )
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
