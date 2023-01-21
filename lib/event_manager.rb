require 'csv'

class EventManager
  attr_accessor :content

  def initialize(file)
    @file_name = file
    @content = CSV.open(
      file,
      headers: true,
      header_converters: :symbol
    )
    content.each do |row|
      name = row[:first_name]
      zipcode = clean_zipcode(row[:zipcode])
      puts "#{name} - #{zipcode}"
    end
  end

  private

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, "0")[0...5]
  end
end
