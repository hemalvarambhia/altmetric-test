require 'json'
require_relative './doi'
require_relative './author'
class Authors
  include Enumerable
  extend Forwardable
  def_delegator :@authors, :[]
  def_delegator :@authors, :empty?
  def_delegator :@authors, :size

  def initialize(authors)
    @authors = authors || []
  end

  def each &block
    @authors.each &block
  end

  def author_of doi
    Authors.new find_all{ |author| author.published? doi }
  end

  def self.load_from file_name
    unless File.exists?(file_name)
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
