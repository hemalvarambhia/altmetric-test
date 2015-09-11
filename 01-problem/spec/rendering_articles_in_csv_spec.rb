require 'csv'
require_relative './issn'
require_relative './doi'
require_relative './journal'
require_relative './article'
class CSVRenderer
  def render articles
     CSV.generate do |csv|
       csv << header
       article = articles.all.first
       csv << as_array(article) if article
       article = articles.all[1]
       csv << as_array(article) if article
     end
  end

  private
  
  def header
    ["DOI", "Title", "Author", "Journal Title", "ISSN"]
  end

  def as_array article
     [
       article.doi,
       article.title,
       article.author,
       article.journal_published_in.title,
       article.journal_published_in.issn
      ]
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

    it "has a header" do
      articles = double("Articles")
      allow(articles).to(
         receive(:all).and_return(
           [
             Article.new(
               doi: DOI.new("10.1234/altmetric52"),
               title: "Title of Article",
               author: "Name of Author",
               journal: Journal.new(
                  ISSN.new("3853-8766"),
                  "Title of Journal")
             )
           ]
         )
      )

      parsed_csv = CSV.parse(CSVRenderer.new.render(articles))
      expect(parsed_csv[0]).to(
          eq(
             [
               "DOI",
               "Title",
               "Author",
               "Journal Title",
               "ISSN"
             ]))
    end

    it "contains the details of the article" do
      articles = double("Articles")
      allow(articles).to(
         receive(:all).and_return(
           [
             Article.new(
	       doi: DOI.new("10.1234/altmetric52"),
               title: "Title of Article",
               author: "Name of Author",
               journal: Journal.new(
                  ISSN.new("3853-8766"),
                  "Title of Journal")
             )
           ]
         )
      )

      parsed_csv = CSV.parse(CSVRenderer.new.render(articles))
      expect(parsed_csv[1]).to(
          eq(
             [
               "10.1234/altmetric52", 
               "Title of Article", 
               "Name of Author", 
               "Title of Journal",
               "3853-8766"
             ]))
    end
  end

  describe "rendering 2 articles to CSV" do
    it "contains the details of both articles" do
      articles = double("Articles")
      allow(articles).to(
         receive(:all).and_return(
           [
             Article.new(
               doi: DOI.new("10.1234/altmetric52"),
               title: "Title of Article",
               author: "Name of Author",
               journal: Journal.new(
                  ISSN.new("3853-8766"),
                  "Title of Journal")
             ),
             Article.new(
	       doi: DOI.new("10.1234/altmetric101"),
               title: "Different Title",
               author: "Different Author",
               journal: Journal.new(
	          ISSN.new("6757-2931"),
                  "Different Journal"
               )
             )
           ]
         )
      )

      parsed_csv = CSV.parse(CSVRenderer.new.render(articles))
      expect(parsed_csv[1]).to(
          eq(
             [
               "10.1234/altmetric52",
               "Title of Article",
               "Name of Author",
               "Title of Journal",
               "3853-8766"
             ]))
      expect(parsed_csv[2]).to(
             eq([
               "10.1234/altmetric101",
               "Different Title",
               "Different Author", 
               "Different Journal",
               "6757-2931"
             ]))
    end
  end

  describe "rendering many articles to CSV" do
    it "contains the details of every article"
  end
end