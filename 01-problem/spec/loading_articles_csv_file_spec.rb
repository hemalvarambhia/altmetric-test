describe "Loading articles from a CSV file" do
  context "when the file does not exist" do
    it "loads no articles" do
      journals = double("Journals")
      author_publications = double("AuthorPublications")
      articles = Articles.load_from(
            "non_existent.csv", 
            journals, 
            author_publications)
 
      expect(articles.all).to be_empty
    end
  end
end