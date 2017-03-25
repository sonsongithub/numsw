require "pathname"
require "tmpdir"

class PlaygroundRunner
  attr_reader :playground_path
  attr_reader :temp_dir

  def run(playground_path)
    @playground_path = playground_path

    @temp_dir = Pathname(Dir.mktmpdir("PlaygroundRunner"))
    puts "working temp dir: #{temp_dir.to_s}"

    Dir.chdir(playground_path)
    sources = Pathname.glob([
      "Sources/**/*.swift",
      "Contents/Sources/**/*.swift"
    ])
    lib_bundle = temp_dir + "lib_bundle.swift"
    concat_sources(sources, lib_bundle)

    for source in Pathname.glob([
      "Contents.swift",
      "Contents/Chapters/**/Contents.swift"
      ])

      main_path = temp_dir + "main.swift"
      content = source.read
      main_path.binwrite(content)

      puts "execute: #{main_path}"

      Dir.chdir(temp_dir) do
        exec([
          "swiftc", "-v",
          "main.swift",
          "lib_bundle.swift",
          "-o", "exe"
          ])
        exec(["./exe"])
      end
    end

    FileUtils.remove_entry_secure(temp_dir)
  end

  def concat_sources(sources, dest)
    handle = dest.open("wb")
    for source in sources
      content = source.read
      handle.write("// #{source.expand_path.to_s}\n")
      handle.write(content)
      handle.write("\n")
    end
    handle.close
  end
end

