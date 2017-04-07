#!/usr/bin/env ruby

require "pathname"
require "optparse"
require_relative "lib/ShellUtil"
require_relative "lib/PlaygroundRunner"

class RunPlaygroundApp
  def main
    opt = OptionParser.new("Usage: #{$0} <playground-path> [options]")
    opt.parse!(ARGV)
    if ARGV.length < 1
      puts opt.help
      return
    end
    playground_path = ARGV[0]

    runner = PlaygroundRunner.new
    runner.run(playground_path)
  end
end

app = RunPlaygroundApp.new
app.main
