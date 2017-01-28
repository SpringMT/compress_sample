require 'benchmark/ips'

require 'json'
require 'snappy'
require 'zlib'
require 'xz'
require 'lz4-ruby'
require 'zstd'

## 前処理

sample_file_name = ARGV[0]

json_data = JSON.parse(IO.read("./samples/#{sample_file_name}"), symbolize_names: true)
json_string = json_data.to_json

Benchmark.ips do |x|
  x.report("snappy") do
    #puts "snappy start"
    #start_time = Time.now
    File.write('./results/json.snappy', Snappy.deflate(json_string))
    #puts "snappy end #{Time.now - start_time}"
  end

  x.report("gzip") do
    #puts 'gzip start'
    #start_time = Time.now
    Zlib::GzipWriter.open('./results/json.gzip') do |gz|
      gz.write json_string
    end
    #puts "gzip end #{Time.now - start_time}"
  end

  x.report("xz") do
    #puts 'xz start'
    #start_time = Time.now
    File.write('./results/json.xz', XZ.compress(json_string))
    #puts "xz end #{Time.now - start_time}"
  end

  x.report("lz4") do
    #puts 'lz4 start'
    #start_time = Time.now
    File.write('./results/json.lz4', LZ4::compress(json_string))
    #puts "lz4 end #{Time.now - start_time}"
  end

  x.report("zstd") do
    #puts 'zstd start'
    #start_time = Time.now
    File.write('./results/json.zstd', Zstd.compress(json_string))
    #puts "zstd end #{Time.now - start_time}"
  end

end
