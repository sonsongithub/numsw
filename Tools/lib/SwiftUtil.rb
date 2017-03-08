class SwiftUtil
  @@indent_regex = /^([ ]*)(.*)$/

  def self.normalize_indent(str)
    return str.gsub("\t", "    ")
  end

  def self.count_indent(line)
    line = normalize_indent(line)
    m = @@indent_regex.match(line)
    if m[2].empty?
      return nil
    end
    return m[1].length
  end

  def self.indent_left(str, width)
    lines = normalize_indent(str).lines
    lines = lines.map {|x|
      indent = count_indent(x)
      if indent
        del_len = [width, indent].min
        x.slice(del_len...x.length)
      else
        x
      end
    }
    return lines.join
  end

  def self.indent_left_max(str)
    indent = normalize_indent(str).lines
      .map {|x| count_indent(x) }
      .select {|x| x }
      .min
    return indent_left(str, indent)
  end
end