require 'csv'

class EventManager
  attr_reader :content

  def initialize(file)
    @file_name = file
    @content = CSV.open(
      file,
      headers: true,
      header_converters: :symbol
    )
    puts "Event Manager Initialized!"
  end

  def show_name(index, header)
    content.read[index][header.to_sym]
  end
end
