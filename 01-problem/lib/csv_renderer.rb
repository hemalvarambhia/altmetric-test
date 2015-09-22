require 'csv'

class CSVRenderer
  def render articles
    CSV.generate do |csv|
      csv << header
      articles.collect{ |article| csv << as_array(article) }
    end
  end

  private

  def header
    ["DOI", "Title", "Author", "Journal Title", "ISSN"]
  end

  def as_array article
    [
        article.doi,
        article.title,
        article.author.join(", "),
        article.journal_published_in.title,
        article.journal_published_in.issn
    ]
  end
end
