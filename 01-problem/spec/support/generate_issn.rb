module GenerateISSN
  def an_issn
    numbers = 0.to(9).to_a
    ISSN.new(
      "#{numbers.sample(4).join}-#{numbers.sample(4).join}")
  end
end
