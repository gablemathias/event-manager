require 'csv'
puts "Event Manager Initialized!"

fname = "event_attendees.csv"

content = CSV.open(fname, headers: true)

content.each do |row|
  p row[2]
end
