require 'spec_helper'
require_relative './file_not_found'
require_relative '../lib/author'
require_relative './doi'

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
  
  def self.load_from file_name
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end
    authors = []
    authors_as_json = JSON.parse(
      File.open(file_name, "r").read)
    authors = authors_as_json.collect do |author_as_json|
      publications = author_as_json["articles"].collect{ |doi|
        DOI.new(doi)
      }
      Author.new(
        author_as_json["name"], publications)
    end.select{|author| author.publications.any?}

    return Authors.new(authors)
  end
end

describe "Loading authors from a JSON file" do
  context "when the file does not exist" do
    it "raises an error" do
      expect(
        lambda {Authors.load_from("non_existent.json")}
      ).to raise_error(FileNotFound)
    end
  end

  context "when the file has an empty JSON array" do
    it "yields no authors" do
       authors = Authors.load_from(
        File.join(fixtures_dir, "no_authors.json")
      )

      expect(authors).to be_empty
    end
  end

  context "when the file consists of one author" do
    context "when that author has no publications" do
      it "yields no authors" do
        authors = Authors.load_from(
          File.join(
          fixtures_dir,
          "one_author_with_no_publication.json")
        )

        expect(authors).to be_empty
      end
    end

    context "when that author has 1 or more publications" do
      it "yields the author" do
         authors = Authors.load_from(
          File.join(
          fixtures_dir,
          "one_author_with_many_publications.json")
        )

        expect(authors.size).to eq(1)
      end
    end
  end

  context "when the file consists of two authors" do
    context "when the authors have 1 or more publications" do
      it "yields both authors"
    end
  end

  context "when the file consists of many authors" do
    context "when the authors have many publications" do
      it "yields every author"
    end
  end
end
