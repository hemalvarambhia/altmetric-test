require 'csv'
require_relative '../lib/issn'
require_relative '../lib/doi'
require_relative '../lib/journal'
require_relative '../lib/article'
require_relative '../lib/articles'
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

def run_renderer(all_articles)
  without_header(
      CSV.parse(CSVRenderer.new.render(all_articles)))
end

describe "Rendering articles to CSV" do
  describe "Rendering no articles" do
    it "contains nothing" do
      articles = Articles.new([])
      parsed_csv = run_renderer(articles)

      expect(parsed_csv).to be_empty
    end
  end

  describe "Rendering 1 article" do
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

      it "contains the details of the article" do
        parsed_csv = run_renderer(@all_articles)

        expect(parsed_csv).to(eq(expected_format(@all_articles)))
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

      it "renders the authors as a comma-separated string" do
         parsed_csv = run_renderer(@all_articles)

         expect(parsed_csv.first["author"]).to(
           eq("Author 1, Author 2"))
      end
    end
  end

  describe "Rendering 2 articles" do
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
      parsed_csv = run_renderer(@all_articles)

      expect(parsed_csv).to(eq(expected_format(@all_articles)))
    end
  end

  describe "Rendering many articles" do
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
      parsed_csv = run_renderer(@all_articles)

      expect(parsed_csv).to(eq(expected_format(@all_articles)))
    end
  end

  describe "Rendering no articles in CSV" do
    it "has the headers" do
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
  end
end
