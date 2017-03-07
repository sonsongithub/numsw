require "pathname"

require_relative "SwiftUtil"

class SwiftScopeReader
  def read(path, head_regex)
    source_lines = path.readlines

    head_line_index = source_lines.find_index {|x|
      head_regex.match(x)
    }
    if ! head_line_index
      return nil
    end

    head_indent = SwiftUtil.count_indent(source_lines[head_line_index])
    if ! head_indent
      raise "invalid indent"
    end

    index = source_lines
      .slice((head_line_index + 1)...source_lines.length)
      .find_index {|x|
        SwiftUtil.count_indent(x) == head_indent
      }
    if index
      foot_line_index = head_line_index + 1 + index
    else
      raise "scope foot not found"
    end

    lines = source_lines.slice(head_line_index..foot_line_index)
    return lines.join
  end
end