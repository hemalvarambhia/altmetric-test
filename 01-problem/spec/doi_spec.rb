require_relative './doi'
describe "Digital object identifiers" do
  describe "a blank DOI" do
    it "is invalid" do
      expect(lambda {DOI.new("")}).to raise_error InvalidDOI
      expect(lambda {DOI.new(nil)}).to raise_error InvalidDOI
    end
  end

  describe "a DOI that does not start with 10" do
    it "is not valid" do
      expect(lambda {DOI.new("90")}).to raise_error(InvalidDOI)
    end
  end

  describe "a DOI that has a valid prefix and no suffix" do
    it "is invalid" do
      expect(lambda {DOI.new("10.1234")}).to raise_error(InvalidDOI)
      expect(lambda {DOI.new("10.1234/")}).to raise_error(InvalidDOI)
      expect(lambda {DOI.new("10.1234/ ")}).to raise_error(InvalidDOI)
    end
  end

  describe "a DOI that has a prefix and suffix" do
    context "prefix has no registrant code" do
      it "is invalid" do
        expect(lambda {DOI.new("10/altmetric121")}).to raise_error(InvalidDOI)
        expect(lambda {DOI.new("10./altmetric121")}).to raise_error(InvalidDOI)
      end
    end

    context "prefix is not separated by a full-stop" do
      it "is invalid" do
        expect(lambda {DOI.new("10,1234/altmetric098")}).to raise_error(InvalidDOI)
      end
    end

    context "both are correctly specified" do
      it "is valid" do
        expect(lambda {DOI.new("10.1234/altmetric345")}).not_to raise_error
        expect(lambda {DOI.new(" 10.1234 / altmetric421 ")}).not_to raise_error
        expect(lambda {DOI.new("10. 1234/altmetric876")}).not_to raise_error
      end
    end
  end
end
