require 'csv'
# Renders Articles to CSV format
module Rendering
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
