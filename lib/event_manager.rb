require 'csv'
puts "Event Manager Initialized!"

fname = "event_attendees.csv"

content = CSV.open(
  fname,
  headers: true,
  header_converters: :symbol
)

content.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end
