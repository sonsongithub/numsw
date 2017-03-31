require_relative "PathUtil"

class SourceDirBuilder
  attr_reader :repo_dir
  attr_reader :dest_dir
  
  def build(repo_dir, dest_dir)
    @repo_dir = repo_dir
    @dest_dir = dest_dir

    Dir.chdir(repo_dir + "Sources/numsw")
    files = Pathname.glob("**/*.swift")
    target = dest_dir + "numsw"
    puts "copy files to: #{target.to_s}"
    PathUtil.copy_files(files, target)

    Dir.chdir(repo_dir + "playgrounds")
    files = Pathname.glob("**/*.swift")
      .select {|x| !x.fnmatch("sandbox/*") }
    target = dest_dir + "Playgrounds"
    puts "copy files to: #{target.to_s}"
    PathUtil.copy_files(files, target)
  end
end