require_relative './issn'
require_relative './journal'
require_relative './journals'

describe "Finding journals by ISSN" do
  context "when the article is found" do
    it "is returned" do
      journals = Journals.new(
        [
          Journal.new(
          ISSN.new("1234-5678"),
          "Journal that exists"
        )])

      journal = journals.
                find_journal_for(
                  ISSN.new("1234-5678")
                )

      expect(journal.title).to eq("Journal that exists")
      expect(journal.issn).to eq(ISSN.new("1234-5678"))
    end

    context "finding a journal for a different ISSN" do
      it "is returned" do
        
        journals = Journals.new(
          [
            Journal.new(
            ISSN.new("9876-5432"),
           "Different journal"
          )])

      journal = journals.find_journal_for(
                  ISSN.new("9876-5432")
                )

      expect(journal.title).to eq("Different journal")
      expect(journal.issn).to eq(ISSN.new("9876-5432"))
      end
    end
  end

  context "when the journal cannot be found" do
    it "returns no journal" do
      journals = Journals.new(
        [
          Journal.new(
            ISSN.new("9876-5432"),
           "Different journal"
        )
        ])

      non_existent = journals.find_journal_for(
        ISSN.new("1234-6878"))

      expect(non_existent).to be_nil
    end
  end
end
