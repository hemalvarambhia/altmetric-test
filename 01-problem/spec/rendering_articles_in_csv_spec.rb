require 'csv'
require_relative '../lib/issn'
require_relative '../lib/doi'
require_relative '../lib/journal'
require_relative '../lib/article'
require_relative '../lib/articles'
require_relative '../lib/csv_renderer'

def to_array(articles)
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

describe "Rendering articles to CSV" do
  describe "rendering no articles to CSV" do
    it "only contains the headers" do
      articles = Articles.new([])

      parsed_csv = CSV.parse(CSVRenderer.new.render(articles))
      expect(parsed_csv.first).to(
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

  describe "rendering 1 article to CSV" do
    context "when the article has one author" do

      before(:each) do
        @all_articles = Articles.new([
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
        articles = double("Articles")
        allow(articles).to(
          receive(:all).and_return(@all_articles))

        parsed_csv = CSV.parse(CSVRenderer.new.render(@all_articles))
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
        parsed_csv = without_header(
          CSV.parse(CSVRenderer.new.render(@all_articles)))

        expect(parsed_csv).to(eq(to_array(@all_articles)))
      end
    end

    context "when the article has multiple authors" do
      before(:each) do
        @all_articles = Articles.new([
             Article.new(
               doi: DOI.new("10.1234/altmetric52"),
               title: "Title of Article",
               author: ["Author 1", "Author 2"],
               journal: Journal.new(
                  ISSN.new("3853-8766"),
                  "Title of Journal")
             )
           ])
      end

      it "presents the authors as a string with authors comma-separated" do
         parsed_csv = without_header(
           CSV.parse(CSVRenderer.new.render(@all_articles)))

         expect(parsed_csv.first[2]).to(
           eq("Author 1, Author 2"))
      end
    end
  end
    

  describe "rendering 2 articles to CSV" do
    before(:each) do
      @all_articles = Articles.new([
         Article.new(
           doi: DOI.new("10.1234/altmetric52"),
           title: "Title of Article",
           author: ["Name of Author"],
           journal: Journal.new(
              ISSN.new("3853-8766"),
              "Title of Journal")
         ),
         Article.new(
           doi: DOI.new("10.1234/altmetric101"),
           title: "Different Title",
           author: ["Different Author"],
           journal: Journal.new(
              ISSN.new("6757-2931"),
              "Different Journal")
         )
      ])
    end

    it "contains the details of both articles" do
      parsed_csv = without_header(
         CSV.parse(CSVRenderer.new.render(@all_articles)))

      expect(parsed_csv).to(eq(to_array(@all_articles)))
    end
  end

  describe "rendering many articles to CSV" do
    before(:each) do
      @all_articles = Articles.new([
             Article.new(
               doi: DOI.new("10.1234/altmetric52"),
               title: "Title of Article",
               author: ["Name of Author"],
               journal: Journal.new(
                  ISSN.new("3853-8766"),
                  "Title of Journal")
             ),
             Article.new(
               doi: DOI.new("10.1234/altmetric101"),
               title: "Different Title",
               author: ["Different Author"],
               journal: Journal.new(
                  ISSN.new("6757-2931"),
                  "Different Journal"
               )
             ),
             Article.new(
               doi: DOI.new("10.1234/altmetric251"),
               title: "Another Title",
               author: ["Another Author"],
               journal: Journal.new(
                  ISSN.new("7771-5323"),
                  "Another Journal"
             )
           )
        ])      
    end

    it "contains the details of every article" do
      parsed_csv = without_header(
          CSV.parse(CSVRenderer.new.render(@all_articles)))

      expect(parsed_csv).to(eq(to_array(@all_articles)))
    end
  end
end
