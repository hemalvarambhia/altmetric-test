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

  before :each do
    @authors_file = File.join(fixtures_dir, "journals.csv")
  end

  context "when the file does not exist" do
    it "raises an error" do
      expect(lambda { Journals.load_from("non_existent.csv") }).to(
      raise_error(FileNotFound))
    end
  end

  context "when the file has no journals (just headers)" do
    it "loads no journals" do
      write_journals_to @authors_file

      journals = Journals.load_from(@authors_file)

      expect(journals).to be_empty
    end
  end

  [1, 2, 3].each do |number_of|
    context "when the file has #{number_of} journal" do
      before :each do
        @expected_journals = Array.new(number_of){ a_journal.build }
        write_journals_to @authors_file, *@expected_journals
      end

      it "loads every article" do
        journals = Journals.load_from(@authors_file)

        expect(journals.all).to(eq(@expected_journals))
      end
    end
  end
end
