#!/usr/bin/env ruby

require "pathname"

require_relative "lib/ShellUtil"

class CiTravisApp
  attr_reader :repo_dir

  def main
    @repo_dir = Pathname(__FILE__).parent.parent.expand_path
    puts "repo_dir: #{repo_dir}"

    test_on_mac
    test_on_ipad
    build_book
  end

  def test_on_mac
    Dir.chdir(repo_dir)
    exec([
      "xcodebuild", "test",
      "-project", "numsw.xcodeproj",
      "-scheme", "numsw",
      ])
  end

  def test_on_ipad
    Dir.chdir(repo_dir + "Playgrounds/sandbox")
    platform = "iOS Simulator"
    os = "10.2"
    name = "iPad Air 2"
    exec([
      "xcodebuild", "test",
      "-workspace", "sandbox.xcworkspace",
      "-scheme", "sandbox",
      "-destination", "platform=#{platform},OS=#{os},name=#{name}"
      ])
  end

  def build_book
    Dir.chdir(repo_dir)
    exec([
      "Tools/build-book.rb"
      ])
  end

end

app = CiTravisApp.new
app.main