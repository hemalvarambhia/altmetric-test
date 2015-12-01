require_relative 'spec_helper'
require 'csv'
require_relative './csv_rendering_helper'

describe 'Rendering articles to CSV' do
  include CSVRenderingHelper
  it_behaves_like 'a renderer'

  before(:each) { @rendering_articles_as_csv = RenderingArticles::AsCSV.new }

  describe 'Rendering no articles in CSV' do
    it 'has just the headers' do
      rendered_articles = CSV.parse(@rendering_articles_as_csv.render(articles(0)))

      expect(rendered_articles.first).to(
          eq(required_headers))
    end
  end

  describe 'Rendering 1 article in CSV' do
    before(:each) do
      @all_articles = articles(1)
    end

    it 'has a header' do
      rendered_articles = CSV.parse(@rendering_articles_as_csv.render(@all_articles))
      expect(rendered_articles[0]).to(
          eq(required_headers))
    end
  end

  def required_headers
    [
      'DOI',
      'Article title',
      'Author name',
      'Journal title',
      'Journal ISSN'
    ]
  end

  def articles(number)
    Articles.new(Array.new(number) { an_article.build })
  end
end
