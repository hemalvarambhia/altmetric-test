# Class to model the concept of a DOI (Digital Object Identifier)
# (see en.wikipedia.org/digital_object_identifier)
class DOI
  def initialize(doi_string)
    @doi = doi_string || ''
    fail Malformed, @doi unless valid?
  end

  def ==(other)
    other.to_s.downcase == to_s.downcase
  end

  def to_s
    components.join('/')
  end

  private

  def valid?
    return false if @doi.empty?

    return false unless prefix.start_with?('10')

    # The registrant code is currently four digits long,
    # but this is not syntactically necessary
    return false unless prefix.match(/10\.\d{4}/)

    return false if suffix.empty?

    true
  end

  def prefix
    components[0] || ''
  end

  def suffix
    components[1] || ''
  end

  def components
    @doi.split('/')
      .map { |component| component.strip }
      .map { |component| component.gsub(/\s+/, '') }
  end

  # Exceptions for when DOI are badly formed
  class Malformed < Exception
    def initialize(doi)
      super "Invalid DOI '#{doi}'. DOIs take the form 10.1234/abcdefg"
    end
  end
end
