require 'spec_helper'
require_relative './file_not_found'
require_relative '../lib/authors'
require_relative '../lib/doi'

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
         expect(authors.first.name).to(
           eq("Author With One or More Publications"))
         expect(authors.first.publications).to(
           eq([
                DOI.new("10.1234/altmetric101"),
                DOI.new("10.1234/altmetric323")
              ]
           ))
      end
    end
  end

  context "when the file consists of two authors" do
    context "when the authors have 1 or more publications" do
      it "yields both authors" do
        authors = Authors.load_from(
          File.join(
          fixtures_dir,
          "two_authors_with_many_publications.json"))
        
        expect(authors.size).to eq(2)
        expect(authors.first.name).to eq("Author With Many Publications")
        expect(authors.first.publications).to(
          eq(
            [
              DOI.new("10.1234/altmetric221"),
              DOI.new("10.1234/altmetric240")
            ]
          )
        )
        expect(authors.last.name).to(
          eq("Another Author With Many Publications"))
        expect(authors.last.publications).to(
          eq([DOI.new("10.1234/altmetric007")]))
      end
    end
  end

  context "when the file consists of many authors" do
    context "when the authors have many publications" do
      it "yields every author" do
        authors = Authors.load_from(
          File.join(fixtures_dir,
                    "many_authors_with_many_publications.json")
        )
        
        expect(authors.first.name).to eq("Author 1")
        expect(authors.first.publications).to(
          eq([
               DOI.new("10.1234/altmetric001"),
               DOI.new("10.1234/altmetric002")
             ])
        )
        expect(authors.all[1].name).to eq("Author 2")
        expect(authors.all[1].publications).to(
          eq([
               DOI.new("10.1234/altmetric110")
             ]
          )
        )
        expect(authors.last.name).to eq("Authors 3")
        expect(authors.last.publications).to(
          eq([
               DOI.new("10.1234/altmetric122"),
               DOI.new("10.1234/altmetric555"),
               DOI.new("10.1234/altmetric098"),
             ]
          )
        )
      end
    end
  end
end
