#!/usr/bin/env ruby

require 'rubygems'
require 'statsd'
require 'munin-ruby'

MUNIN_HOST = ENV['MUNIN_HOST'] || "localhost"
MUNIN_PORT = ENV['MUNIN_PORT'] || 4949

STATSD_HOST = ENV['STATSD_HOST'] || "localhost"
STATSD_PORT = ENV['STATSD_PORT'] || 8125

SCHEMABASE = ENV['SCHEMABASE'] || "munin_statsd"

node = Munin::Node.new(MUNIN_HOST, MUNIN_PORT)
statsd = Statsd.new(STATSD_HOST, STATSD_PORT)
statsd.namespace = SCHEMABASE

def statsd_method(config, name)
  type = config["metrics"][name]["type"] rescue nil # if there is no configuration or some other problems
  case type
  when "DERIVE", "COUNTER", "ABSOLUTE"
    return :count
  when "GAUGE", nil
    return :gauge
  else
    STDERR.puts "WARNING: unknown munin type #{type} .. using GAUGE instead"
    return :gauge
  end
end

services = node.list
STDOUT.puts "collection stuff for services #{services.inspect}"
STDOUT.puts "collection configs"
configs = node.config services
STDOUT.puts "collection data"
all_data = node.fetch services
services.each do |service|
  config = configs[service]
  data   = all_data[service]

  next if data.nil?

  data.each_pair do |name, value|
    statsd.send(statsd_method(config, name), "#{config["graph"]["category"]}.#{service}.#{name}", value)
  end
end
