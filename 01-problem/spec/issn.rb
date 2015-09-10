class InvalidISSN < Exception
end

class ISSN

  def initialize issn_string
    @issn = (issn_string || "").strip
    raise InvalidISSN.new("ISSN cannot be blank") if @issn.empty?

    if digits.size != 8
      raise InvalidISSN.new("ISSNs must consist of 8 digits")
    end
      
    @issn = @issn.insert(4, "-") if not @issn.include?("-")

    unless @issn=~/^\d{4}-\d{4}$/
      raise InvalidISSN.new("ISSN '#{@issn}' is badly formed")
    end
  end

  def to_s
    @issn
  end

  private 
  def digits
    @issn.scan(/\d/).collect{|digit| digit.to_i}
  end
end
