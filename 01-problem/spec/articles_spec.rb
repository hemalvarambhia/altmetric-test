require 'spec_helper'
require_relative '../lib/articles'
describe Articles do
  it 'is initially empty' do
     expect(Articles.new).to be_empty
  end
end