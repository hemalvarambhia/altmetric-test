module GenerateDOI
  def a_doi
    suffix = "altmetric#{rand(1000000)}"
    registrant_code = (0..9).to_a.sample(4).join
    DOI.new("10.#{registrant_code}/#{suffix}")
  end
end
