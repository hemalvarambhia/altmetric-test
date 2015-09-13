require 'json'
require_relative './doi'
require_relative './author'
class Authors
  def initialize(articles)
    @articles = articles || []
  end

  def empty?
    @articles.empty?
  end

  def size
    @articles.size
  end

  def all
    @articles
  end

  def first
    @articles.first
  end

  def last
    @articles.last
  end
  
  def self.load_from file_name
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end
    
    authors = []
    authors_as_json = JSON.parse(
      File.open(file_name, "r").read)
    authors = authors_as_json.collect do |author_as_json|
      publications = author_as_json["articles"].
                     collect{ |doi| DOI.new(doi)}
      Author.new(author_as_json["name"], publications)
    end.select{|author| author.has_publications?}

    return Authors.new(authors)
  end
end
