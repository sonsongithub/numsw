#!/usr/bin/env ruby

require "pathname"

require_relative "lib/ShellUtil"

class CiTravisApp
  attr_reader :repo_dir

  def main
    @repo_dir = Pathname(__FILE__).parent.parent.expand_path
    puts "repo_dir: #{repo_dir}"

    run_xcode_tasks

    build_books
    
    run_books
  end

  def run_xcodebuild(action, scheme, sdk, destination)
    Dir.chdir(repo_dir) {
      destination_str = destination
        .to_a.map {|x| "#{x[0]}=#{x[1]}" }.join(",")
      exec([
        "xcodebuild", action,
        "-workspace", "numsw.xcworkspace",
        "-scheme", scheme,
        "-destination", destination_str,
        "-sdk", sdk
        ])
    }
  end

  def run_xcode_tasks
    mac_dest = {
      "platform" => "macOS"
    }

    ios_dest = {
      "platform" => "iOS Simulator",
      "OS" => "10.2",
      "name" => "iPad Air 2"
    }

    run_xcodebuild("test" , "numsw"               , "macosx"          , mac_dest)
    run_xcodebuild("build", "numsw"               , "iphonesimulator" , ios_dest)
    run_xcodebuild("build", "NumswRenderer-iOS"   , "iphonesimulator" , ios_dest)
    run_xcodebuild("build", "NumswRenderer-macOS" , "macosx"          , mac_dest)
    run_xcodebuild("test" , "sandbox"             , "iphonesimulator" , ios_dest)
  end

  def build_books
    Dir.chdir(repo_dir)

    exec([
      "Tools/build-book.rb"
      ])
  end

  def run_books
    Dir.chdir(repo_dir)

    exec([
      "Tools/run-playground.rb",
      "Release/numsw-xcode.playground"
      ])

    exec([
      "Tools/run-playground.rb",
      "Release/numsw-ipad.playgroundbook"
      ])
  end

end

app = CiTravisApp.new
app.main