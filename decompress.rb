require 'benchmark/ips'

require 'json'
require 'snappy'
require 'zlib'
require 'xz'
require 'lz4-ruby'
require 'zstd'

## 前処理

sample_file_name = ARGV[0]

#json_data = JSON.parse(IO.read("./samples/#{sample_file_name}"), symbolize_names: true)
#json_string = json_data.to_json

Benchmark.ips do |x|
  x.report("snappy") do
    #puts "snappy start"
    #start_time = Time.now
    Snappy.inflate IO.read("./results/#{sample_file_name}.snappy")
    #puts "snappy end #{Time.now - start_time}"
  end

  x.report("gzip") do
    #puts 'gzip start'
    #start_time = Time.now
    gz = Zlib::GzipReader.new( File.open("./results/#{sample_file_name}.gzip") )
    gz.read
    gz.close
    #puts "gzip end #{Time.now - start_time}"
  end

  x.report("xz") do
    #puts 'xz start'
    #start_time = Time.now
    XZ.decompress IO.read("./results/#{sample_file_name}.xz")
    #puts "xz end #{Time.now - start_time}"
  end

  x.report("lz4") do
    #puts 'lz4 start'
    #start_time = Time.now
    LZ4::decompress IO.read("./results/#{sample_file_name}.lz4")
    #puts "lz4 end #{Time.now - start_time}"
  end

  x.report("zstd") do
    #puts 'zstd start'
    #start_time = Time.now
    Zstd.decompress IO.read("./results/#{sample_file_name}.zstd")
    #puts "zstd end #{Time.now - start_time}"
  end

end
