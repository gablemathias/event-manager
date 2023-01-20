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
    return "00000" if zipcode.nil?
    return zipcode.rjust(5, "0") if zipcode.length < 5
    return zipcode.slice(0...5) if zipcode.length > 5

    zipcode
  end

end
