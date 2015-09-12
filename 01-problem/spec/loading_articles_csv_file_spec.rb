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
end
