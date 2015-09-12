require_relative './journals'
describe "Loading journals from csv files" do
  context "when the file does not exist" do
    it "raises an error"
  end

  context "when the file has no journals (just headers)" do
    it "loads no journals"
  end

  context "when the file has 1 journal" do
    it "loads that article"
  end

  context "when the file has 2 journals" do
    it "loads both journals"
  end

  context "when the file has many journals" do
    it "loads every journal"
  end
end
