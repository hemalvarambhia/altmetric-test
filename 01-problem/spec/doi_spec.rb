describe "Digital object identifiers" do
  class InvalidDOI < Exception
  end

  class DOI
    def initialize doi_string
      @doi = doi_string
    end

    def valid?
      return false if @doi.nil?
      return false if @doi.empty?
    end
  end
  
  describe "a blank DOI" do
    it "is invalid" do
      expect(DOI.new("")).to_not be_valid
      expect(DOI.new(nil)).to_not be_valid
    end
  end
end
