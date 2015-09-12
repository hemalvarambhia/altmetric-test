require_relative './doi'
require_relative './issn'
require_relative './journal'
require_relative './articles'

describe "Loading articles from a CSV file" do
  context "when the file does not exist" do
    it "raises an error" do
      journals = double("Journals")
      author_publications = double("AuthorPublications")
      expect(lambda {Articles.load_from(
            "non_existent.csv", 
            journals, 
            author_publications)}).to raise_error
    end
  end

  context "the file is empty (contains just headers)" do
    it "yields no articles" do
      articles = Articles.load_from(
        File.join(
        File.dirname(__FILE__),
        "fixtures",
        "no_articles.csv"),
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
    it "yields the articles" do
      articles = Articles.load_from(
        File.join(
        File.dirname(__FILE__),
        "fixtures",
        "one_article.csv"),
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
end
