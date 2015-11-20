require 'spec_helper'
require_relative '../lib/articles'
describe Articles do
  it 'is initially empty' do
     expect(Articles.new).to be_empty
  end

  describe 'loading articles from a CSV file' do
    context 'when the file does not exist' do
      it 'raises an error' do
        articles = Articles.new
        expect(-> { articles.load_from('non_existent.csv') }).to(
          raise_error(FileNotFound)
        )
      end
    end
  end
end