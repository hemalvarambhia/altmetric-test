require_relative '../lib/journal'
describe "Equating journals" do
  it "is reflexive" do
    journal_1 = Journal.new(
      ISSN.new("0024-9319"),
      "Journal"
    )

    expect(journal_1).to eq(journal_1)
  end

  it "is transitive" do
     journal_1 = Journal.new(
      ISSN.new("0024-9319"),
      "A Journal"
     )
     journal_2 = Journal.new(
       ISSN.new("0024-9319"),
       "A Journal"
     )
     journal_3 = Journal.new(
       ISSN.new("0024-9319"),
       "A Journal"
     )

     expect(journal_1).to eq(journal_2)
     expect(journal_2).to eq(journal_3)
     expect(journal_1).to eq(journal_3)
  end

  it "is symmetric" do
     journal_1 = Journal.new(
       ISSN.new("0032-1478"),
       "Some Journal"
     )
     journal_2 = Journal.new(
       ISSN.new("0032-1478"),
       "Some Journal"
     )

     expect(journal_1).to eq(journal_2)
     expect(journal_2).to eq(journal_1)
  end
end
