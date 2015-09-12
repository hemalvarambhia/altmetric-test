require_relative './doi'
require_relative './issn'
require_relative './journal'
require_relative './articles'

class Author
  attr_reader :name, :publications
  def initialize(name, publications)
    @name = name
    @publications = publications
  end
end

def fixtures_dir
  File.join(
    File.dirname(__FILE__),
    "fixtures"
  )
end

describe "Loading articles from a CSV file" do
  context "when the file does not exist" do
    it "raises an error" do
      journals = double("Journals")
      author_publications = double("Authors")
      expect(lambda {Articles.load_from(
            "non_existent.csv", 
            journals, 
            author_publications)}).to raise_error(Exception)
    end
  end

  context "the file is empty (contains just headers)" do
    it "yields no articles" do
      articles = Articles.load_from(
        File.join(fixtures_dir, "no_articles.csv"),
        double("Journals"),
        double("Authors")
      )
      
      expect(articles).to be_empty
    end
  end

  context "when the file contains one article" do
    before(:each) do
      @journals = double("Journals")
      allow(@journals).to(
        receive(:find_journal_for).
        with(ISSN.new("1337-8688")).
        and_return(
          Journal.new(
          ISSN.new("1337-8688"),
          "Shanahan, Green and Ziemann"))
      )

      @authors = double("Authors")
      allow(@authors).to(
        receive(:author_of).
        with(DOI.new("10.1234/altmetric0")).
        and_return("Amari Lubowitz")
      )
    end
    
    it "yields the article" do
      articles = Articles.load_from(
        File.join(fixtures_dir, "one_article.csv"),
        @journals,
        @authors
      )
      
      article = articles.all.first
      expect(article.doi).to eq("10.1234/altmetric0")
      expect(article.title).to eq("Small Wooden Chair")
      expect(article.author).to eq("Amari Lubowitz")
      expect(article.journal_published_in.issn).to(
        eq("1337-8688"))
      expect(article.journal_published_in.title).to(
        eq("Shanahan, Green and Ziemann"))
    end
  end

  context "a file with 2 articles" do
    before :each do
      @journals = double("Journals")
      [
        Journal.new(
          ISSN.new("1337-8688"),
          "Shanahan, Green and Ziemann"
      ),
        Journal.new(
          ISSN.new("2542-5856"),
          "Wilkinson, Gaylord and Gerlach"
        )                                    
      ].each do |journal|
        allow(@journals).to(
          receive(:find_journal_for).
          with(journal.issn).
          and_return(journal)
        )                                          
       end                                           

      @authors = double("Authors")
      [
        Author.new(
        "Amari Lubowitz",
         [DOI.new("10.1234/altmetric0")]
      ),
         Author.new(
        "Lenny Kshlerin",
         [DOI.new("10.1234/altmetric100")]
      ),
        
      ].each do |author|
        author.publications.each do |doi|
          allow(@authors).to(
            receive(:author_of).
            with(doi).
            and_return(author.name)
          )
        end
      end
    end
   
    it "yields both articles" do
      articles = Articles.load_from(
        File.join(fixtures_dir, "two_articles.csv"),
        @journals,
        @authors
      ).all

      article = articles.first
      expect(article.doi).to eq("10.1234/altmetric0")
      expect(article.title).to eq("Small Wooden Chair")
      expect(article.author).to eq("Amari Lubowitz")
      expect(article.journal_published_in.title).to(
        eq("Shanahan, Green and Ziemann"))
      expect(article.journal_published_in.issn).to eq("1337-8688")

      article = articles.last
      expect(article.doi).to eq("10.1234/altmetric100")
      expect(article.title).to eq("Ergonomic Rubber Shirt")
      expect(article.author).to eq("Lenny Kshlerin")
      expect(article.journal_published_in.title).to(
        eq("Wilkinson, Gaylord and Gerlach"))
      expect(article.journal_published_in.issn).to eq("2542-5856")
    end
  end
end
