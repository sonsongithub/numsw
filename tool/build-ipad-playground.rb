#!/usr/bin/env ruby

require "pathname"
require "fileutils"
require "tmpdir"

require_relative "lib/SourceDirBuilder"

class BuildIpadPlaygroundApp
	attr_reader :repo_dir
	attr_reader :temp_dir
	attr_reader :package_name
	attr_reader :final_dest_path

	def contents_swift_path
		return "Contents/Chapters/Chapter1.playgroundchapter/Pages/Graph.playgroundpage"
	end

	def main
		@repo_dir = Pathname(__FILE__).parent.parent.expand_path
		puts "repository dir: #{repo_dir.to_s}"

		@temp_dir = Pathname(Dir.mktmpdir("numsw-ipad"))
		puts "working temp dir: #{temp_dir.to_s}"

		@package_name = "numsw-ipad"

		@final_dest_path = repo_dir + "playbook" + "#{package_name}.playgroundbook"
		FileUtils.rm_rf(final_dest_path)

		src = repo_dir + "playbook/ipad/#{package_name}.playgroundbook"
		dest = temp_dir
		puts "copy template: #{src.to_s}"
		FileUtils.cp_r(src, dest)

		temp_package_dir = temp_dir + "#{package_name}.playgroundbook"

		SourceDirBuilder.new.tap {|b|
			b.build(repo_dir, temp_package_dir + "Contents/Sources")
		}

		src = repo_dir + "playbook/ipad/Contents.swift"
		dest = temp_package_dir + contents_swift_path
		puts "copy contents.swift: #{src.to_s}"
		FileUtils.cp_r(src, dest)

		src = temp_package_dir
		dest = repo_dir + "playbook"
		puts "move output: #{dest}"
		FileUtils.mv(src, dest)

		FileUtils.remove_entry_secure(temp_dir)
	end
end

app = BuildIpadPlaygroundApp.new
app.main