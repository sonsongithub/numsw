require "shellwords"

def exec(cmd)
  if cmd.is_a?(Array)
    exec(cmd.shelljoin)
    return
  end

  puts "exec: [#{cmd}]"
  system(cmd)
  if ! $?.success?
    raise "exec failled: [#{cmd}]"
  end
end
