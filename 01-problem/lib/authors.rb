require 'json'
require_relative './doi'
require_relative './author'
# A class that models a list of authors with journal publication
class Authors
  include Enumerable
  extend Forwardable
  def_delegators :@authors, :[], :empty?, :size

  def initialize(authors = [])
    @authors = authors || []
  end

  def self.from_file(file_name)
    fail FileNotFound, file_name unless File.exist?(file_name)

    authors_as_json = JSON.parse(
        File.open(file_name, 'r').read)
    authors = authors_as_json.map do |author_as_json|
      publications = author_as_json['articles'].map { |doi| DOI.new(doi) }
      Research::Author.new(author_as_json['name'], publications)
    end

    Authors.new(authors.select { |author| author.has_publications? })

  end

  def each(&block)
    @authors.each(&block)
  end

  def author_of(doi)
    @authors.select { |author| author.published? doi }
  end
end
