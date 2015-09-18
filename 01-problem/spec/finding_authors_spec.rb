require 'spec_helper'
require_relative '../lib/doi'
require_relative '../lib/author'
require_relative '../lib/authors'

describe "Finding authors by their publications" do
  include GenerateDOI
  context "when there is 1 author of the publication" do
    it "yields the author" do
      publication_of_interest = DOI.new("10.1234/altmetric101")
      authors = some_authors(
        an_author,
        an_author,
        an_author.of_publications(publication_of_interest)
      )
      authors = authors.author_of publication_of_interest

      expect(authors.size).to eq(1)
      authors.each do |author|
        expect(author.publications).to(
          include(publication_of_interest))
      end
    end
  end

  context "when there is another author for a different publication" do
    it "yields that author" do
      publication = DOI.new("10.1234/altmetric171")
      authors = some_authors(
        an_author,
        an_author,
        an_author.of_publications(publication)
      )
      authors = authors.author_of publication

      expect(authors.size).to eq(1)
      authors.each do |author|
        expect(author.publications).to(include(publication))
      end
    end
  end

  context "when there are several authors of the publication" do
    it "yields them all" do
      publication = DOI.new("10.1234/altmetric171")
      authors = some_authors(
        an_author.of_publications(a_doi, publication),
        an_author.of_publications(publication),
        an_author.of_publications(a_doi, publication, a_doi),
        an_author
      )

      authors = authors.author_of publication

      expect(authors.size).to be > 1
      authors.each do |author|
        expect(author.publications).to(include(publication))
      end
    end
  end

  context "when there are no authors of the publication" do
    it "yields none" do
      publication = DOI.new("10.1234/altmetric999")
      authors = some_authors(an_author, an_author, an_author)

      author = authors.author_of publication

      expect(author).to be_empty
    end
  end
end
