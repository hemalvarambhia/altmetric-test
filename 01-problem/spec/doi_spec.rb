describe "Digital object identifiers" do
  class DOI
    def initialize doi_string
      @doi = doi_string || ""
    end

    def valid?
      return false if @doi.empty?
      
      return false unless prefix.start_with?("10")

      # The registrant code is currently four digits long,
      # but this is not syntactically necessary
      return false unless prefix.match(/10\.\d{4}/)

      return false if suffix.empty?

      return true
    end

    def to_s
      components.join("/")
    end

    private
    def prefix
      components[0] || ""
    end

    def suffix
      components[1] || ""
    end
    
    def components
      @doi.split("/").
        collect{|component| component.strip}.
        collect{|component| component.gsub(/\s+/, "")}
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

    context "both are correctly specified" do
      it "is valid" do
        expect(DOI.new("10.1234/altmetric345")).to be_valid
        expect(DOI.new(" 10.1234 / altmetric421 ")).to be_valid
        expect(DOI.new("10. 1234/altmetric876")).to be_valid
      end
    end
  end
end
