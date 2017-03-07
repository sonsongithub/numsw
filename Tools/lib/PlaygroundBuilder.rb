require "pathname"
require "fileutils"
require "tmpdir"

require_relative "SourceDirBuilder"

class PlaygroundBuilder
  attr_reader :repo_dir
  attr_reader :temp_dir
  attr_reader :temp_playground_path
  attr_reader :package_name
  attr_reader :final_dest_path
  attr_accessor :target

  def initialize(repo_dir)
    @repo_dir = repo_dir
  end

  def build(target,
    ext,
    sources_path)
    @target = target

    puts "repository dir: #{repo_dir.to_s}"

    @package_name = "numsw-#{target}"

    @temp_dir = Pathname(Dir.mktmpdir(package_name))
    puts "working temp dir: #{temp_dir.to_s}"

    @final_dest_path = repo_dir + "Release/#{package_name}#{ext}"
    FileUtils.rm_rf(final_dest_path)

    @temp_playground_path = temp_dir + "#{package_name}#{ext}"

    src = repo_dir + "PlaygroundBook/#{target}-template"
    dest = temp_playground_path
    puts "copy template: #{src.to_s}"
    FileUtils.cp_r(src, dest)

    SourceDirBuilder.new.tap {|b|
      b.build(repo_dir, temp_playground_path + sources_path)
    }

    src = temp_playground_path
    dest = final_dest_path
    FileUtils.mkdir_p(dest.parent)
    puts "move output: #{dest}"
    FileUtils.mv(src, dest)

    FileUtils.remove_entry_secure(temp_dir)
  end
end