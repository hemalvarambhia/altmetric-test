describe "ISSNs" do
  class ISSN
    def initialize issn_string
      @issn = issn_string
    end

    def valid?
      false
    end
  end
  describe "a blank ISSN" do
    it "is invalid" do
      expect(ISSN.new("")).to_not be_valid
    end
  end
end
