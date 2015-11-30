require_relative 'spec_helper'
require 'csv'
require_relative './csv_rendering_helper'

describe 'Rendering articles to CSV' do
  include CSVRenderingHelper
  it_behaves_like 'a renderer'

  describe 'Rendering no articles in CSV' do
    it 'has just the headers' do
      articles = Articles.new

      rendered_articles = CSV.parse(CSVRenderer.new.render(articles))
      expect(rendered_articles.first).to(
          eq(required_headers))
    end
  end

  describe 'Rendering 1 article in CSV' do
    before(:each) do
      @all_articles = Articles.new(
          [
            an_article
          ].map { |article| article.build })
    end

    it 'has a header' do
      rendered_articles = CSV.parse(CSVRenderer.new.render(@all_articles))
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
end
