require 'json'
require_relative './json_rendering_helper'

describe 'Rendering articles to JSON' do
  include JSONRenderingHelper
  it_behaves_like 'a renderer'
end
