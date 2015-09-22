require 'spec_helper'
require_relative '../lib/journals'
require_relative '../lib/file_not_found'

describe "Loading journals from csv files" do
  matcher :eq do |expected|
    match do |journal|
      are_equal = true
      journal.each_index do |index|
        are_equal = are_equal && are_equal?(expected[index], journal[index])
      end

      return expected.size == journal.size && are_equal
    end

    def are_equal?(expected, actual)
      actual.issn == expected.issn && actual.title == expected.title
    end
  end

  context "when the file does not exist" do
    it "raises an error" do
      expect(lambda { Journals.load_from("non_existent.csv") }).to(
          raise_error(FileNotFound))
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
    before :each do
      @expected_journals = Array.new(1){ a_journal.build }
      write_journals_to File.join(fixtures_dir, "journals.csv"), *@expected_journals
    end

    it "loads every article" do
      journals = Journals.load_from(File.join(fixtures_dir, "journals.csv"))

      expect(journals.all).to(eq(@expected_journals))
    end
  end

  context "when the file has 2 journals" do
    before :each do
      @expected_journals = Array.new(2){ a_journal.build }
      write_journals_to File.join(fixtures_dir, "journals.csv"), *@expected_journals
    end

    it "loads every journals" do
      journals = Journals.load_from(File.join(fixtures_dir, "journals.csv"))

      expect(journals.all).to(eq(@expected_journals))
    end
  end

  context "when the file has 3 journals" do
    before :each do
      @expected_journals = Array.new(3) { a_journal.build }
      write_journals_to File.join(fixtures_dir, "journals.csv"), *@expected_journals
    end

    it "loads every journal" do
      journals = Journals.load_from(File.join(fixtures_dir, "journals.csv"))

      expect(journals.all).to(eq(@expected_journals))
    end
  end
end
