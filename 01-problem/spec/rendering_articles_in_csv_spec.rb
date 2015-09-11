require_relative './issn'
require_relative './doi'
require_relative './journal'
require_relative './article'

describe "Rendering articles to CSV" do
  describe "rendering no articles to CSV" do
    it "only contains the headers"
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