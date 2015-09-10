describe "ISSNs" do
  class InvalidISSN < Exception
  end
  
  class ISSN
    def initialize issn_string
      @issn = issn_string || ""
      raise InvalidISSN.new("ISSN cannot be blank") if @issn.empty?
    end

    def valid?
      all_digits = @issn.scan(/\d/).collect{|digit| digit.to_i}
      return false if all_digits.size != 8
    end
  end
  
  describe "a blank ISSN" do
    it "is invalid" do
      expect(lambda { ISSN.new("") }).to raise_error(InvalidISSN)
      expect(lambda {ISSN.new(nil) }).to raise_error(InvalidISSN)
    end
  end

  describe "an ISSN with fewer than 8 characters" do
    it "is invalid" do
      expect(ISSN.new("1234-56")).to_not be_valid
      expect(ISSN.new("1514")).to_not be_valid
    end
  end

  describe "an ISSN with more than 8 characters" do
    it "is invalid" do
      expect(ISSN.new("43565-32932")).to_not be_valid
    end
  end

  describe "an ISSN with only letter characters" do
    it "is invalid" do
      expect(ISSN.new("aybc-riet")).to_not be_valid
    end
  end                   
end
