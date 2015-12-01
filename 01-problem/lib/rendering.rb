require_relative './json_renderer'
require_relative './csv_renderer'
# A Factory class that creates a rendering object from the given format
module Rendering
  def self.renderer_for(format)
    case format
      when 'json'
        return Rendering::AsJSON.new
      when 'csv'
        return Rendering::AsCSV.new
    end
  end

  class AsJSON
    def render(articles)
      JSON.pretty_generate(articles.map { |article| as_hash(article) })
    end

    private

    def as_hash(article)
      {
          'doi' => article.doi,
          'title' => article.title,
          'author' => article.authors.map { |author| author.name }.join(', '),
          'journal' => article.journal_published_in.title,
          'issn' => article.journal_published_in.issn
      }
    end
  end

  class AsCSV
    def render(articles)
      CSV.generate do |csv|
        csv << header
        articles.map { |article| csv << as_array(article) }
      end
    end

    private

    def header
      ['DOI', 'Article title', 'Author name', 'Journal title', 'Journal ISSN']
    end

    def as_array(article)
      [
          article.doi,
          article.title,
          article.authors.map {|author| author.name }.join(', '),
          article.journal_published_in.title,
          article.journal_published_in.issn
      ]
    end
  end
end
