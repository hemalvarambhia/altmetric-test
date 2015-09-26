require_relative './json_renderer'
require_relative './csv_renderer'
# A Factory class that creates a rendering object from the given format
class RenderingFactory
  def renderer_for(format)
    case format
    when 'json'
      return JSONRenderer.new
    when 'csv'
      return CSVRenderer.new
    end
  end
end
