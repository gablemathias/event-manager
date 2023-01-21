require 'csv'
require 'google/apis/civicinfo_v2'

class EventManager
  attr_accessor :content

  def initialize(file)
    @file_name = file
    @content = CSV.open(
      file,
      headers: true,
      header_converters: :symbol
    )
    @civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    @civic_info.key = api_key
    show
  end

  def show
    content.each do |row|
      name = row[:first_name]
      zipcode = clean_zipcode(row[:zipcode])

      puts "#{name} - #{zipcode} - #{legislators(zipcode)}"
    end
  end

  private

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, "0")[0...5]
  end

  def legislators(zipcode)
    legislators = @civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators.officials.map(&:name).join(', ')
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end

  def api_key
    'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  end
end
