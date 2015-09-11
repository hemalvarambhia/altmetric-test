require 'json'
require_relative './doi'
require_relative './issn'
class Journal
  attr_reader :title
  def initialize(issn, title)
    @issn = issn
    @title = title
  end

  def issn
    @issn.to_s
  end
end

class Article
  attr_reader :title, :author
  def initialize(hash)
    @doi = hash[:doi]
    @title = hash[:title] 
    @author = hash[:author]
    @journal = hash[:journal]
  end

  def journal_published_in
    @journal
  end

  def doi
    @doi.to_s
  end
end

class JSONRenderer
  def render articles
    [as_hash(articles.all.first)].to_json
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

describe "A JSON array of 1 article" do
  it "contains the details of the article" do
    articles = double("Articles")
    allow(articles).to(
      receive(:all).and_return(
      [
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
      ]
    ))
   
    parsed_json = JSON.parse(JSONRenderer.new.render(articles))
    expect(parsed_json).to(
      eq(
        [
          {
            "doi" => "10.1234/altmetric0",
            "title" => "Title of Article",
            "author" => "Name of Author",
            "journal" => "Name of Journal",
            "issn" => "0378-5955"
          }
        ]
      ))
  end
end

