#! /usr/bin/env ruby

require 'json'
require 'time'
require 'date'

def localize_time(time_string)
  time_format = "%Y-%m-%d %H:%M"
  return DateTime.parse(time_string).new_offset(DateTime.now.offset).strftime(time_format)
end

def localize_diference(start_time, end_time)
  
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

start_date = '2025-03-01' 
end_date = '2025-03-30' 

json_string = `timew export #{start_date} - #{end_date}`
time_data = JSON.parse(json_string)



html = <<~HTML
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>JSON to HTML</title>
      <style>
          table, th, td {
            border: 1px solid black;
            padding: 1em;
            border-collapse: collapse;
          }
      </style>
  </head>
  <body>
      <h1>Data</h1>


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



