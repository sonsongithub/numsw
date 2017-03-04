class SourceDirBuilder
	attr_reader :repo_dir
	attr_reader :dest_dir
	
	def build(repo_dir, dest_dir)
		@repo_dir = repo_dir
		@dest_dir = dest_dir

		target = dest_dir + "Sources"
		puts "make root Sources directory:　#{target.to_s}"
		FileUtils.mkdir_p(target)

		target = dest_dir + "Sources" + "numsw"
		puts "make numsw directory: #{target.to_s}"
		FileUtils.mkdir_p(target)

		dest = dest_dir + "Sources" + "numsw"
		src_dir = repo_dir + "Sources"
		Dir.chdir(src_dir.to_s)
		for x in Pathname.glob("*")
			src = src_dir + x
			puts "copy entry: #{x.to_s}"
			FileUtils.cp_r(src, dest)
		end

		target = dest_dir + "Sources" + "playgrounds"
		puts "make playgrounds directory: #{target.to_s}"
		FileUtils.mkdir_p(target)

		dest = dest_dir + "Sources" + "playgrounds"
		src_dir = repo_dir + "playgrounds"
		Dir.chdir(src_dir.to_s)
		for x in Pathname.glob("*")
			src = src_dir + x
			puts "copy entry: #{x.to_s}"
			FileUtils.cp_r(src, dest)
		end

	end

end