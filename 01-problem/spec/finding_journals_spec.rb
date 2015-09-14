require_relative '../lib/journals'

describe "Finding journals by ISSN" do
  context "when the article is found" do
    it "is returned" do
      journals = Journals.new(
        [
          Journal.new(ISSN.new("0032-1478"), "Journal that exists")
        ])

      journal = journals.find_journal_for(ISSN.new("0032-1478"))

      expect(journal).to(
        eq(Journal.new(ISSN.new("0032-1478"), "Journal that exists")))
    end

    context "finding a journal for a different ISSN" do
      it "is returned" do
        journals = Journals.new(
          [
            Journal.new(ISSN.new("0378-5955"), "Different journal")
          ])

      journal = journals.find_journal_for(ISSN.new("0378-5955"))

      expect(journal).to(
        eq(Journal.new(ISSN.new("0378-5955"), "Different journal")))
      end
    end
  end

  context "when the journal cannot be found" do
    it "returns no journal" do
      journals = Journals.new(
        [
          Journal.new(ISSN.new("0024-9319"), "Different journal")
        ])

      non_existent = journals.find_journal_for(ISSN.new("0378-5955"))

      expect(non_existent).to be_nil
    end
  end
end
