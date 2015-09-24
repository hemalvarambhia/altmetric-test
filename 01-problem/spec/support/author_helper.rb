require_relative '../../lib/author'
require_relative '../../lib/authors'
require_relative './generate_doi'
module AuthorHelper
  def write_authors_to authors_file, *authors
    File.delete(authors_file) if File.exists?(authors_file)
    authors_to_hash = authors.collect { |author|
      {
          "name" => author.name,
          "articles" => author.publications
      }
    }

    File.open(authors_file, "w") do |file|
      file.puts authors_to_hash.to_json
    end
  end

  def an_author
    Builder.new
  end

  class Builder
    include GenerateDOI
    def initialize
      @name = "::Author::"
      @publications = Array.new(3){|index| a_doi}
    end

    def who_published(*dois)
      @publications += dois.to_a

      self
    end

    def with_no_publications
      @publications = []

      self
    end

    def build
      Author.new(@name, @publications)
    end
  end
end
