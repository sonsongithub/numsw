#!/usr/bin/env ruby

require "pathname"

require_relative "lib/PlaygroundBuilder"

class BuildBookApp
  def main
    repo_dir = Pathname(__FILE__).parent.parent.expand_path

    builder = PlaygroundBuilder.new(repo_dir)
    builder.build("ipad", 
      ".playgroundbook", 
      "Contents/Sources")

    builder = PlaygroundBuilder.new(repo_dir)
    builder.build("xcode", 
      ".playground", 
      "Sources")
  end
end

app = BuildBookApp.new
app.main
