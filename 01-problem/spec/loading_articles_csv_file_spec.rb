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

  context "when the file contains 2 articles" do
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

  context "when the file contains many articles" do
    before(:each) do
      @journals = double("Journals")
      [
        Journal.new(
          ISSN.new("1337-8688"),
          "Shanahan, Green and Ziemann"
      ),
        Journal.new(
          ISSN.new("2542-5856"),
          "Wilkinson, Gaylord and Gerlach"
        ),
        Journal.new(
          ISSN.new("3775-0307"),
          "Hahn and Sons"
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
         Author.new(
           "Howard Spinka Jr.", 
           [DOI.new("10.1234/altmetric103")]
         )       
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
    
    it "yields every articles" do
       articles = Articles.load_from(
        File.join(fixtures_dir, "many_articles.csv"),
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

       article = articles[1]
       expect(article.doi).to eq("10.1234/altmetric100")
       expect(article.title).to eq("Ergonomic Rubber Shirt")
       expect(article.author).to eq("Lenny Kshlerin")
       expect(article.journal_published_in.title).to(
         eq("Wilkinson, Gaylord and Gerlach"))
       expect(article.journal_published_in.issn).to eq("2542-5856")

       article = articles.last
       expect(article.doi).to eq("10.1234/altmetric103")
       expect(article.title).to eq("Fantastic Granite Computer")
       expect(article.author).to eq("Howard Spinka Jr.")
       expect(article.journal_published_in.title).to(
         eq("Hahn and Sons"))
       expect(article.journal_published_in.issn).to eq("3775-0307")
    end
  end

  context "when the file contains articles with duplicate DOIs and missing journals" do
    before :each do
      @journals = double("Journals")
      [
        Journal.new(
          ISSN.new("9667-8162"),
          "Gleichner, Shanahan and Predovic"
      ),
        Journal.new(
          ISSN.new("8768-8891"),
          "Becker LLC"
        ),
      ].each do |journal|
        allow(@journals).to(
          receive(:find_journal_for).
          with(journal.issn).
          and_return(journal)
        )                                          
      end
      [
        # These are ISSNs for non-existent journals
        ISSN.new("3760-2228"),
        ISSN.new("2781-6347")
      ].each do |non_existent_issn|
        allow(@journals).to(
           receive(:find_journal_for).
           with(non_existent_issn).
           and_return(nil)
        )
      end
      
      @authors = double("Authors")
      allow(@authors).to(
        receive(:author_of).
        with(DOI.new("10.1234/altmetric156")).
              and_return("Perry Ondricka"))
        
    end
      
    it "takes the article that was published in a real journal" do
      articles = Articles.load_from(
        File.join(
        fixtures_dir,
        "articles_with_duplicate_dois_with_missing_journals.csv"),
        @journals,
        @authors
      ).all

      expect(articles.size).to eq(1)
      expect(articles.first.doi).to eq("10.1234/altmetric156")
      expect(articles.first.journal_published_in.issn).to(
        eq("8768-8891")
      )    
    end
  end
end
