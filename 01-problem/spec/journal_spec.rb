require_relative './journal'
describe "Equating journals" do
  it "is reflexive" do
    journal_1 = Journal.new(
      ISSN.new("1234-5678"),
      "Journal"
    )

    expect(journal_1).to eq(journal_1)
  end

  it "is transitive" do
     journal_1 = Journal.new(
      ISSN.new("1244-4478"),
      "A Journal"
     )
     journal_2 = Journal.new(
       ISSN.new("1244-4478"),
       "A Journal"
     )
     journal_3 = Journal.new(
       ISSN.new("1244-4478"),
       "A Journal"
     )

     expect(journal_1).to eq(journal_2)
     expect(journal_2).to eq(journal_3)
     expect(journal_1).to eq(journal_3)
  end

  it "is symmetric" do
     journal_1 = Journal.new(
       ISSN.new("2222-5678"),
       "Some Journal"
     )
     journal_2 = Journal.new(
       ISSN.new("2222-5678"),
       "Some Journal"
     )

     expect(journal_1).to eq(journal_2)
     expect(journal_2).to eq(journal_1)
  end
end
