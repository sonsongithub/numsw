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

  def run_xcode_tasks
    mac_sdk = "macosx"
    mac_dest = {
      "platform" => "macOS"
    }

    ios_sdk = "iphonesimulator"
    ios_dest = {
      "platform" => "iOS Simulator",
      "OS" => "10.3",
      "name" => "iPad Air 2"
    }

    run_xcodebuild("numsw"              , "test" , mac_sdk, mac_dest)
    run_xcodebuild("numsw"              , "build", ios_sdk, ios_dest)
    run_xcodebuild("NumswRenderer-iOS"  , "build", ios_sdk, ios_dest)
    run_xcodebuild("NumswRenderer-macOS", "build", mac_sdk, mac_dest)
    run_xcodebuild("sandbox"            , "test" , ios_sdk, ios_dest)
  end

  def run_xcodebuild(scheme, action, sdk, destination)
    Dir.chdir(repo_dir) {
      destination_str = destination
        .to_a.map {|x| "#{x[0]}=#{x[1]}" }.join(",")
      exec([
        "xcodebuild",
        "-workspace", "numsw.xcworkspace",
        "-scheme", scheme,
        "-sdk", sdk,
        "-destination", destination_str,
        "-verbose",
        action
        ])
    }
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
