require 'csv'
require_relative './csv_rendering_helper'

describe "Rendering articles to CSV" do
  include CSVRenderingHelper
  it_behaves_like "a renderer"

  describe "Rendering no articles in CSV" do
    it "has the headers" do
      articles = Articles.new([])

      rendered_articles = CSV.parse(CSVRenderer.new.render(articles))
      expect(rendered_articles.first).to(
          eq(
              [
                  "DOI",
                  "Title",
                  "Author",
                  "Journal Title",
                  "ISSN"
              ]))
    end
  end

  describe "Rendering 1 article in CSV" do
    before(:each) do
      @all_articles = Articles.new(
          [
              Article.new(
                  doi: DOI.new("10.1234/altmetric52"),
                  title: "Title of Article",
                  author: ["Name of Author"],
                  journal: Journal.new(
                      ISSN.new("0032-1478"),
                      "Title of Journal")
              )
          ])
    end

    it "has a header" do
      rendered_articles = CSV.parse(CSVRenderer.new.render(@all_articles))
      expect(rendered_articles[0]).to(
          eq(
              [
                  "DOI",
                  "Title",
                  "Author",
                  "Journal Title",
                  "ISSN"
              ]))

    end
  end
end
