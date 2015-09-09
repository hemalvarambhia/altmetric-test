describe "Digital object identifiers" do
  class InvalidDOI < Exception
  end

  class DOI
    def initialize doi_string
      if doi_string.empty?
        raise InvalidDOI.new "DOIs cannot be blank"
      end
    end
  end
  
  describe "a blank DOI" do
    it "is invalid" do
      expect(lambda {DOI.new("")}).to raise_error(InvalidDOI)
    end
  end
end
