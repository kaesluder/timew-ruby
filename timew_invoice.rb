#! /usr/bin/env ruby

require 'json'
require 'time'
require 'date'
require 'open3'

def localize_time(time_string)
  time_format = "%Y-%m-%d %H:%M"
  if time_string
    DateTime.parse(time_string).new_offset(DateTime.now.offset).strftime(time_format)
  else
    ""
  end
end

def localize_diference(start_time, end_time)
  
  if (!start_time || !end_time)
    return ''
  end

  endt = DateTime.parse(end_time)
  startt = DateTime.parse(start_time)
  diff = ( endt - startt ) * 24


  return format('%.2f', diff)
end

def format_row(time_data_row)
  time_start = time_data_row["start"]
  time_end = time_data_row["end"]
  html = <<~HTML
  <tr>
    <td>#{localize_time(time_start)}</td>
    <td>#{localize_time(time_end)}</td>
    <td>#{time_data_row["tags"]}</td>
    <td>#{localize_diference(time_start, time_end)}</td>
  </tr>
  HTML

  return html
end


# timew export 2025-03-01 - 2025-03-30

start_date = ARGV[0] 
end_date = ARGV[1]

if (!start_date || !end_date)
  abort "Error: missing start or end date"
end

cmd = "timew export #{start_date} - #{end_date}"

stdout, stderr, status = Open3.capture3(cmd)

if status.success?
  json_string = stdout
  # Process json_string
else
  abort "Error running timew: #{stderr}"
end

time_data = JSON.parse(json_string)



html = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Time Report: #{start_date} &ndash; #{end_date}</title>
      <style>
          table, th, td {
            border: 1px solid black;
            padding: 1em;
            border-collapse: collapse;
          }
      </style>
  </head>
  <body>
      <h1>Time Report: #{start_date} &ndash; #{end_date}</h1>


      <table>
      <tr>
        <th>Start</th>
        <th>End</th>
        <th>Tags</th>
        <th>Total</th>
      </tr>
HTML

time_data.each do |row|
  html << format_row(row)
end 

html << <<~HTML
  </table>
  </body>
  </html>
HTML

puts html

puts localize_time("20250319T160000Z")



