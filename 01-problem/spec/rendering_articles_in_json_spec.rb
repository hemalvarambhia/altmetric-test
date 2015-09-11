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

def as_hash articles
  articles.collect{|article|
    {
     "doi" => article.doi,
     "title" => article.title,
     "author" => article.author,
     "journal" => article.journal_published_in.title,
     "issn" => article.journal_published_in.issn
    }
  }
end

describe "A JSON array of 1 article" do
   before(:each) do
     @all_articles = [
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
   end

  it "contains the details of the article" do
    articles = double("Articles")
    allow(articles).to(receive(:all).and_return(@all_articles))
   
    parsed_json = JSON.parse(JSONRenderer.new.render(articles))
    expect(parsed_json).to(eq(as_hash(@all_articles)))
  end
end

describe "A JSON array of two articles" do
  before(:each) do
    @all_articles = [
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
      ]
  end

  it "contains the details of both articles" do
    articles = double("Articles")
    allow(articles).to(receive(:all).and_return(@all_articles))

    parsed_json = JSON.parse(JSONRenderer.new.render(articles))
    expect(parsed_json).to(eq(as_hash(@all_articles)))
  end
end

describe "A JSON array of many articles" do
  before(:each) do
    @all_articles = [
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
      ]
  end

  it "contains the details of all the articles" do
    articles = double("Articles")
    allow(articles).to(
      receive(:all).and_return(@all_articles))

    parsed_json = JSON.parse(JSONRenderer.new.render(articles))
    expect(parsed_json).to(eq(as_hash(@all_articles)))
  end	 
end

