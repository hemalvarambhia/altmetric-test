describe "Digital object identifiers" do
  class InvalidDOI < Exception
  end

  class DOI
    def initialize doi_string
      @doi = doi_string
    end

    def valid?
      return false if @doi.empty?
    end
  end
  
  describe "a blank DOI" do
    it "is invalid" do
      expect(DOI.new("")).to_not be_valid
#      expect(lambda {DOI.new(nil)}).to raise_error(InvalidDOI)
    end
  end
end
