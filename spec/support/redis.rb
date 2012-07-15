# make sure we can run redis
#

if !system("which redis-server")
  puts '', "** can't find `redis-server` in your path"
  abort ''
end

#
# start our own redis when the tests start,
# kill it when they end
#

dir = File.dirname(File.expand_path(__FILE__))

at_exit do
  next if $!

  pid = `ps -A -o pid,command | grep [r]edis-spec.conf`
  puts "Killing test redis server..."
  `rm -f #{dir}/dump.rdb`
  Process.kill("KILL", pid.to_i)
end

puts "Starting redis for testing at localhost:9802..."
`redis-server #{dir}/redis-spec.conf`
Afterburn.redis = 'localhost:9802'