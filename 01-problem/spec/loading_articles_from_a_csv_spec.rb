require_relative './articles'
describe "Loading articles from a CSV file" do
  context "when the file does not exist" do
    it "yields no articles" do
      articles = Articles.load_from(
        "non_existent.csv",
        double("Journals"),
        double("Authors"))
      expect(articles).to be_empty
    end
  end
end
