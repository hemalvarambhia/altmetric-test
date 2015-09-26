# A domain-level exception for badly formatted ISSNs
class InvalidISSN < Exception
  def initialize(issn)
    message = "Invalid ISSN '#{issn}'. ISSNs take the form dddd-dddd."
    super message
  end
end

# Class that models a domain value, the ISSN
class ISSN
  def initialize(issn_string)
    @issn = (issn_string || '').strip

    fail InvalidISSN, @issn if @issn.empty?

    fail InvalidISSN, @issn if digits.size != 8

    @issn = @issn.insert(4, '-') unless @issn.include?('-')

    fail InvalidISSN, @issn  unless @issn =~ /^\d{4}-\d{4}$/
  end

  def to_s
    @issn
  end

  def ==(other)
    @issn == other.to_s
  end

  private

  def digits
    @issn.scan(/\d/).map { |digit| digit.to_i }
  end
end
