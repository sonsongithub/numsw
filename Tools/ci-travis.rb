#!/usr/bin/env ruby

require "pathname"

require_relative "lib/ShellUtil"

class CiTravisApp
  attr_reader :repo_dir

  def main
    @repo_dir = Pathname(__FILE__).parent.parent.expand_path
    puts "repo_dir: #{repo_dir}"

    test_on_mac

    test_sandbox_on_ipad

    build_book
  end

  def test_on_mac
    run_test(
      "numsw", 
      "macOS")
  end

  def test_sandbox_on_ipad
    run_test(
      "sandbox", 
      "iOS Simulator", { 
        "OS" => "10.2",
        "name" => "iPad Air 2"
      })
  end

  def run_test(scheme, platform, destination_params={})
    Dir.chdir(repo_dir) {
      destination_params["platform"] = platform
      destination = destination_params
        .to_a.map {|x| "#{x[0]}=#{x[1]}" }.join(",")
      exec([
        "xcodebuild", "test",
        "-workspace", "numsw.xcworkspace",
        "-scheme", scheme,
        "-destination", destination
        ])
    }
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