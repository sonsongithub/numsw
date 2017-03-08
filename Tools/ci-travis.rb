#!/usr/bin/env ruby

require "pathname"

class CiTravisApp
  def main
    repo_dir = Pathname(__FILE__).parent.parent.expand_path
    puts "repo_dir: #{repo_dir}"
  end
end

app = CiTravisApp.new
app.main