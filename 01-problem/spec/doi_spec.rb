describe "Digital object identifiers" do
  class DOI
    def initialize doi_string
      @doi = doi_string || ""
    end

    def valid?
      return false if @doi.empty?
      return false unless @doi.start_with?("10")
      prefix, suffix = @doi.split("/")
      return false if suffix.nil?
      true
    end
  end
  
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
    end
  end
end
