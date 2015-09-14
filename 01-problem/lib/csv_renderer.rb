require 'csv'

class CSVRenderer
  def render articles
    CSV.generate do |csv|
      csv << header
      articles.all.collect{ |article|
        csv << as_array(article) if article
      }
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
