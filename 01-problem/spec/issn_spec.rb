describe "ISSNs" do
  class ISSN
    def initialize issn_string
      @issn = issn_string || ""
    end

    def valid?
      all_digits = @issn.scan(/\d/).collect{|digit| digit.to_i}
      return false if all_digits.size != 8
      digits = all_digits.first(7)
      sum = 0
      digits.each_index do |index|
        sum += ((all_digits.size - index) * digits[index])
      end

      remainder = sum % 11
      check_digit = 11 - remainder
      
      check_digit == all_digits.last      
    end
  end
  
  describe "a blank ISSN" do
    it "is invalid" do
      expect(ISSN.new("")).to_not be_valid
      expect(ISSN.new(nil)).to_not be_valid
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

  describe "an 8-digit ISSN" do
    context "the check digit is incorrect" do
      it "is invalid" do
        expect(ISSN.new("0378-5951")).to_not be_valid
      end
    end

    context "the check digit is correct" do
      it "is valid" do
        expect(ISSN.new("0378-5955")).to be_valid
        expect(ISSN.new("03785955")).to be_valid
      end
    end
  end

  describe "an ISSN with only letter characters" do
    it "is invalid" do
      expect(ISSN.new("aybc-riet")).to_not be_valid
    end
  end                   
end
