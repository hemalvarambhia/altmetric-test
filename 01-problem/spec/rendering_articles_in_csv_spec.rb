require 'csv'
require_relative './issn'
require_relative './doi'
require_relative './journal'
require_relative './article'
class CSVRenderer
  def render articles
    ["DOI", "Title", "Author", "Journal Title", "ISSN"].to_csv
  end

end

describe "Rendering articles to CSV" do
  describe "rendering no articles to CSV" do
    it "only contains the headers" do
      articles = double("Articles")
      allow(articles).to(receive(:all).and_return([]))

      parsed_csv = CSV.parse(CSVRenderer.new.render(articles))
      expect(parsed_csv.first).to eq(["DOI", "Title", "Author", "Journal Title", "ISSN"])
    end
  end

  describe "rendering 1 article to CSV" do
    it "contains the details of the article"
  end

  describe "rendering 2 articles to CSV" do
    it "contains the details of both articles"
  end

  describe "rendering many articles to CSV" do
    it "contains the details of every article"
  end
end