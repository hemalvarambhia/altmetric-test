class InvalidISSN < Exception
end

class ISSN

  def initialize issn_string
    @issn = (issn_string || "").strip
    if @issn.empty?
      raise InvalidISSN.new(
          "Invalid ISSN '#{@issn}'. ISSNs take the form dddd-dddd")
    end
    if digits.size != 8
      raise InvalidISSN.new(
            "Invalid ISSN '#{@issn}'. ISSNs take the form dddd-dddd")
    end
      
    @issn = @issn.insert(4, "-") if not @issn.include?("-")

    unless @issn=~/^\d{4}-\d{4}$/
      raise InvalidISSN.new(
           "Invalid ISSN '#{@issn}'. ISSNs take the form dddd-dddd")
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
