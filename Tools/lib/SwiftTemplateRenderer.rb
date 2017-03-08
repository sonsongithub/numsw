require "pathname"

require_relative "SwiftScopeReader"
require_relative "SwiftUtil"

class SwiftTemplateRenderer
  attr_reader :search_paths

  def render(template_path,
    search_paths)
    puts "render template: #{template_path}"
    @search_paths = search_paths

    template = template_path.read
    ret = template.gsub(/\/\*\${(.*)}\*\//) {
      render_template_value($1)
    }
    return ret
  end

  def render_template_value(key)
    value = search_template_value(key)
    if ! value
      raise "template value not found: #{key}"
    end

    # 外側をはがす
    lines = value.lines
    lines = lines.slice(1..(lines.length - 2))
    value = lines.join

    # indentを消す
    value = SwiftUtil.indent_left_max(value)
    return value.strip
  end

  def search_template_value(key)
    regex = Regexp.compile("#{Regexp.escape(key)}")

    for search_path in search_paths
      Dir.chdir(search_path)
      for path in Pathname.glob("**/*.swift")
        path = path.expand_path
        reader = SwiftScopeReader.new
        value = reader.read(path, regex)
        if value
          return value
        end
      end
    end

    return nil
  end
end