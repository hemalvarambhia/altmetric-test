require 'json'
require_relative '../lib/doi'
require_relative '../lib/issn'
require_relative '../lib/journal'
require_relative '../lib/article'
require_relative '../lib/articles'
class JSONRenderer
  def render articles
    articles.all.collect{|article| as_hash(article)}.to_json
  end

  private

  def as_hash article
    {
      "doi" => article.doi,
      "title" => article.title,
      "author" => article.author,
      "journal" => article.journal_published_in.title,
      "issn" => article.journal_published_in.issn
    }
  end
end

def convert_to_hash articles
  articles.all.collect{|article|
    {
     "doi" => article.doi.to_s,
     "title" => article.title,
     "author" => article.author,
     "journal" => article.journal_published_in.title,
     "issn" => article.journal_published_in.issn.to_s
    }
  }
end

describe "A JSON array of 1 article" do
   before(:each) do
     @all_articles = Articles.new([
        Article.new(
        {
          doi: DOI.new("10.1234/altmetric0"),
          title: "Title of Article",
          author: "Name of Author",
          journal: Journal.new(
            ISSN.new("0378-5955"),
            "Name of Journal")
        }
       )
    ])
   end

  it "contains the details of the article" do
    parsed_json = JSON.parse(JSONRenderer.new.render(@all_articles))

    expect(parsed_json).to(eq(convert_to_hash(@all_articles)))
  end
end

describe "A JSON array of two articles" do
  before(:each) do
    @all_articles = Articles.new([
        Article.new(
        {
          doi: DOI.new("10.1234/altmetric0"),
          title: "Title of Article",
          author: "Name of Author",
          journal: Journal.new(
            ISSN.new("0378-5955"),
            "Name of Journal")
        }
       ),
       Article.new(
        {
          doi: DOI.new("10.1234/altmetric1"),
          title: "Different Title",
          author: "Different Author",
          journal: Journal.new(
            ISSN.new("5966-4542"),
            "Different Journal")
        }
       )
      ])
  end

  it "contains the details of both articles" do
    parsed_json = JSON.parse(JSONRenderer.new.render(@all_articles))

    expect(parsed_json).to(eq(convert_to_hash(@all_articles)))
  end
end

describe "A JSON array of many articles" do
  before(:each) do
    @all_articles = Articles.new([
        Article.new(
         {
           doi: DOI.new("10.1234/altmetric0"),
           title: "Title of Article",
           author: "Name of Author",
           journal: Journal.new(
             ISSN.new("0378-5955"),
             "Name of Journal")
         }
       ),
       Article.new(
        {
          doi: DOI.new("10.1234/altmetric1"),
          title: "Different Title",
          author: "Different Author",
          journal: Journal.new(
            ISSN.new("5966-4542"),
            "Different Journal")
        }
       ),
       Article.new(
        {
           doi: DOI.new("10.1234/altmetric2"),
           title: "Another Title",
           author: "Another Author",
           journal: Journal.new(
             ISSN.new("6078-3332"),
             "Another Journal")
        }
       )
      ])
  end

  it "contains the details of all the articles" do
    parsed_json = JSON.parse(JSONRenderer.new.render(@all_articles))

    expect(parsed_json).to(eq(convert_to_hash(@all_articles)))
  end	 
end

describe "A JSON array of no articles" do
  it "contains nothing" do
    no_articles = Articles.new([])

    parsed_json = JSON.parse(JSONRenderer.new.render(no_articles))

    expect(parsed_json).to be_empty
  end
end
