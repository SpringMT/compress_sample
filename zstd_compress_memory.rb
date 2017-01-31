require 'benchmark/ips'

require 'json'
require 'zstd'

require 'objspace'                                                                                                                               

#str = 'a' * 10000000
#a = (1..1000000).map { |i| [i, i] }; `ps -o rss= -p #{Process.pid}`.to_i

p "#{ObjectSpace.memsize_of_all/1000} #{ObjectSpace.count_objects} #{`ps -o rss= -p #{Process.pid}`.to_i}"

sample_file_name = ARGV[0]

json_data = JSON.parse(IO.read("./samples/#{sample_file_name}"), symbolize_names: true)
json_string = json_data.to_json

i = 0

while true do
  Zstd.compress(json_string)
  if ((i % 10000) == 0 )
     puts "count:#{i}\truby_memory:#{ObjectSpace.memsize_of_all/1000}\trss:#{`ps -o rss= -p #{Process.pid}`.to_i}"
  end
  i += 1
end
