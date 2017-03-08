class SourceDirBuilder
  attr_reader :repo_dir
  attr_reader :dest_dir
  
  def build(repo_dir, dest_dir)
    @repo_dir = repo_dir
    @dest_dir = dest_dir

    target = dest_dir
    puts "make root Sources directory: #{target.to_s}"
    FileUtils.mkdir_p(target)

    target = dest_dir + "numsw"
    puts "make numsw directory: #{target.to_s}"
    FileUtils.mkdir_p(target)

    dest = dest_dir + "numsw"
    Dir.chdir(repo_dir + "Sources")
    for src in Pathname.glob("*.swift")
      src = src.expand_path
      puts "copy entry: #{src.to_s}"
      FileUtils.cp_r(src, dest)
    end

    target = dest_dir + "Playgrounds"
    puts "make playgrounds directory: #{target.to_s}"
    FileUtils.mkdir_p(target)

    dest = dest_dir + "Playgrounds"
    Dir.chdir(repo_dir + "playgrounds")
    for src in Pathname.glob("*.swift")
      src = src.expand_path
      puts "copy entry: #{src.to_s}"
      FileUtils.cp_r(src, dest)
    end

  end

end