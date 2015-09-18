require_relative '../../lib/issn'
module GenerateISSN
  def an_issn
    numbers = 0.upto(9).to_a
    parts = [numbers.sample(4).join, numbers.sample(4).join]
    ISSN.new(
      "#{parts.first}-#{parts.last}")
  end
end
