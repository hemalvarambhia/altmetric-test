require 'csv'
require_relative './renderer_contract_spec'
require_relative '../lib/csv_renderer'

def expected_format(articles)
   articles.all.collect do |article|
      [
        article.doi.to_s,
        article.title,
        article.author.join(","),
        article.journal_published_in.title,
        article.journal_published_in.issn.to_s
      ]
   end
end

def without_header(csv_rows)
  csv_rows.drop(1)
end

def render(all_articles)
  without_header(
      CSV.parse(CSVRenderer.new.render(all_articles)))
end

describe "Rendering articles to CSV" do
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
                      ISSN.new("3853-8766"),
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
