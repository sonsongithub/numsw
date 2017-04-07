require "shellwords"

def exec(cmd)
  if cmd.is_a?(Array)
    return exec(cmd.shelljoin)
  end

  puts "exec: [#{cmd}]"
  system(cmd)
  if ! $?.success?
    raise "exec failled: [#{cmd}]"
  end
end

def exec_capture(cmd)
  if cmd.is_a?(Array)
    return exec_capture(cmd.shelljoin)
  end

  puts "exec: [#{cmd}]"
  ret = `#{cmd}`
  if ! $?.success?
    raise "exec failed: [#{cmd}]"
  end

  return ret
end