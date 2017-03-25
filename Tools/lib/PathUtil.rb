require "pathname"
require "fileutils"

class PathUtil
  def self.copy_files(files, dest_root)
    for src in files
      dest = dest_root + src
      dest_dir = dest.parent
      if !dest_dir.directory?
        FileUtils.mkdir_p(dest_dir)
      end
      FileUtils.copy_file(src, dest)
    end
  end
end