class InvalidISSN < Exception
  def initialize(issn)
    super "Invalid ISSN '#{issn}'. ISSNs take the form dddd-dddd. Check that the check digit is correct"
  end

end

class ISSN
  def initialize issn_string
    @issn = (issn_string || "").strip
    if @issn.empty?
      raise InvalidISSN.new(@issn)
    end
    if digits.size != 8
      raise InvalidISSN.new(@issn)
    end

    @issn = @issn.insert(4, "-") if not @issn.include?("-")

    unless @issn=~/^\d{4}-\d{4}$/
      raise InvalidISSN.new(@issn)
    end

    raise InvalidISSN.new(@issn) if check_digit != digits.last
  end

  def to_s
    @issn
  end

  def ==(other)
    @issn == other.to_s
  end

  private
  def digits
    @issn.scan(/\d/).collect{|digit| digit.to_i}
  end

  def check_digit
    check_digit_value = 0
    digits.first(7).each_with_index { |digit, index|
      check_digit_value += (digit * (8 - index))
    }

    11 - (check_digit_value % 11)
  end
end
