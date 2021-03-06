require "json"
require "erb"

module Chartkick
  module Helper

    def line_chart(data_source, options = {})
      chartkick_chart "LineChart", data_source, options
    end

    def pie_chart(data_source, options = {})
      chartkick_chart "PieChart", data_source, options
    end

    def column_chart(data_source, options = {})
      chartkick_chart "ColumnChart", data_source, options
    end

    def bar_chart(data_source, options = {})
      chartkick_chart "BarChart", data_source, options
    end

    def area_chart(data_source, options = {})
      chartkick_chart "AreaChart", data_source, options
    end

    private

    def chartkick_chart(klass, data_source, options, &block)
      @chartkick_chart_id ||= 0
      options = options.dup
      height = options.delete(:height) || "300px"
      # content_for: nil must override default
      content_for = options.has_key?(:content_for) ? options.delete(:content_for) : Chartkick.content_for

      if (element_id = options.delete(:id)).blank?
        element_id = "chart-#{@chartkick_chart_id += 1}"
        html = <<HTML
<div id="#{ERB::Util.html_escape(element_id)}" style="height: #{ERB::Util.html_escape(height)}; text-align: center; color: #999; line-height: #{ERB::Util.html_escape(height)}; font-size: 14px; font-family: 'Lucida Grande', 'Lucida Sans Unicode', Verdana, Arial, Helvetica, sans-serif;">
  Loading...
</div>
HTML
      else
        html = ''
      end

     js = <<JS
<script type="text/javascript">
  new Chartkick.#{klass}(#{element_id.to_json}, #{data_source.to_json}, #{options.to_json});
</script>
JS
      if content_for
        content_for(content_for) { js.respond_to?(:html_safe) ? js.html_safe : js }
      else
        html += js
      end

      html.respond_to?(:html_safe) ? html.html_safe : html
    end

  end
end
