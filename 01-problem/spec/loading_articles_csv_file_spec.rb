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
end
