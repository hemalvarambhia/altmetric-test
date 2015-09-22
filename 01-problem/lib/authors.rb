require 'json'
require_relative './doi'
require_relative './author'
class Authors
  include Enumerable
  def initialize(authors)
    @authors = authors || []
  end

  def empty?
    @authors.empty?
  end

  def size
    @authors.size
  end

  def all
    @authors
  end

  def last
    @authors.last
  end

  def each &block
    @authors.each &block
  end

  def author_of doi
    Authors.new find_all{ |author| author.published? doi }
  end

  def self.load_from file_name
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end

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
