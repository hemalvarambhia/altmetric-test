require 'spec_helper'
require_relative '../lib/journals'
require_relative '../lib/file_not_found'

describe "Loading journals from csv files" do
  context "when the file does not exist" do
    it "raises an error" do
      expect(lambda {
               Journals.load_from("non_existent.csv")
             }).to raise_error(FileNotFound)
    end
  end

  context "when the file has no journals (just headers)" do
    it "loads no journals" do
      journals = Journals.load_from(
        File.join(fixtures_dir, "no_journals.csv")
      )

      expect(journals).to be_empty
    end
  end

  context "when the file has 1 journal" do
    it "loads that article" do
      journals = Journals.load_from(
        File.join(
        fixtures_dir,
        "one_journal.csv")
      )
      
      expect(journals.size).to eq(1)
      expect(journals.first).to(
        eq(
          Journal.new(
          ISSN.new("2885-6503"),
          "Sporer, Kihn and Turner"))
      )
    end
  end

  context "when the file has 2 journals" do
    it "loads both journals" do
      journals = Journals.load_from(
        File.join(
        fixtures_dir,
        "two_journals.csv"
      )
      )
      
      expect(journals.first).to(
        eq(
          Journal.new(
          ISSN.new("1167-8230"),
          "Bartell-Collins")
        )
      )
      expect(journals.last).to(
        eq(
          Journal.new(
          ISSN.new("2885-6503"),
          "Sporer, Kihn and Turner"
        )
        )
      )
    end
  end

  context "when the file has many journals" do
    it "loads every journal" do
       journals = Journals.load_from(
        File.join(
        fixtures_dir,
        "many_journals.csv"
      )
      )
      
      expect(journals.first).to(
        eq(
          Journal.new(
          ISSN.new("1167-8230"),
          "Bartell-Collins")
        )
      )
      expect(journals.all[1]).to(
        eq(
          Journal.new(
          ISSN.new("2885-6503"),
          "Sporer, Kihn and Turner"
        )
        )
      )
      expect(journals.last).to(
        eq(
          Journal.new(
          ISSN.new("0225-5454"),
          "Durgan Group"
        ) 
        )
      )
    end
  end
end
