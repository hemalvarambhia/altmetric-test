require_relative './json_renderer'
require_relative './csv_renderer'

class RenderingFactory
  def renderer_for(format)
    case format
      when "json"
        return JSONRenderer.new
      when "csv"
        return CSVRenderer.new
      end
  end
end
