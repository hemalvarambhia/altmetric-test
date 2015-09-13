require 'json'

class JSONRenderer
  def render articles
    articles.all.collect{|article| as_hash(article)}.to_json
  end

  private

  def as_hash article
    {
      "doi" => article.doi,
      "title" => article.title,
      "author" => article.author,
      "journal" => article.journal_published_in.title,
      "issn" => article.journal_published_in.issn
    }
  end
end
