#!/usr/bin/env ruby

gem 'gnuplot'
require 'rubygems'
require 'gnuplot'
require 'date'

def convert_apache_timestamp_to_unix(apache_timestamp)
  DateTime.strptime(apache_timestamp, "%d/%b/%Y:%H:%M:%S %Z").to_time.to_i
end

interval = 300 # 5 minutes
date_regexp = /\[(?<date>.+)\]/
times = []
requests = []
count = 0
end_time = 0

ARGF.each_line.each_with_index do |l, l_no|
  match = l.match(date_regexp)
  next unless match

  line_time = convert_apache_timestamp_to_unix(match[:date])
  end_time = line_time + interval if l_no.zero?

  if line_time < end_time
    count += 1
  else
    times << end_time - 10
    requests << count
    end_time += interval
    count = 1
  end
end

exit if times.compact.empty?

Gnuplot.open do |gp|
  Gnuplot::Plot.new(gp) do |plot|
    plot.xdata 'time'
    plot.format 'x "%H:%M:%S"'
    plot.timefmt 'x "%s"'
    plot.term 'png truecolor'
    plot.xlabel 'Time (UTC)'
    plot.xtics 'rotate by -90'
    plot.ylabel 'Requests'
    plot.style 'fill transparent solid 0.5 noborder'
    plot.output 'plot.png'
    plot.data = [Gnuplot::DataSet.new([times, requests]) do |ds|
      ds.using = '1:2'
      ds.with = 'boxes'
      ds.title = ''
    end]
  end
end
