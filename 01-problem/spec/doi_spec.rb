require_relative './doi'
describe "Digital object identifiers" do
  describe "a blank DOI" do
    it "is invalid" do
      expect(DOI.new("")).to_not be_valid
      expect(DOI.new(nil)).to_not be_valid
    end
  end

  describe "a DOI that does not start with 10" do
    it "is not valid" do
      expect(DOI.new("90")).to_not be_valid
    end
  end

  describe "a DOI that has a valid prefix and no suffix" do
    it "is invalid" do
      expect(DOI.new("10.1234")).to_not be_valid
      expect(DOI.new("10.1234/")).to_not be_valid
      expect(DOI.new("10.1234/ ")).to_not be_valid
    end
  end

  describe "a DOI that has a prefix and suffix" do
    context "prefix has no registrant code" do
      it "is invalid" do
        expect(DOI.new("10/altmetric121")).to_not be_valid
        expect(DOI.new("10./altmetric121")).to_not be_valid
      end
    end

    context "prefix is not separated by a full-stop" do
      it "is invalid" do
        expect(DOI.new("10,1234/altmetric098")).to_not be_valid
      end
    end

    context "both are correctly specified" do
      it "is valid" do
        expect(DOI.new("10.1234/altmetric345")).to be_valid
        expect(DOI.new(" 10.1234 / altmetric421 ")).to be_valid
        expect(DOI.new("10. 1234/altmetric876")).to be_valid
      end
    end
  end
end
