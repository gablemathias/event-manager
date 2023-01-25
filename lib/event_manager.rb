require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

class EventManager
  attr_accessor :content, :zipcode, :legislator_list
  attr_reader :id, :name

  def initialize(file)
    @file_name = file
    @content = CSV.open(
      file,
      headers: true,
      header_converters: :symbol
    )
    @civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    @civic_info.key = api_key
    create
  end

  def create
    content.each do |row|
      @id = row[0]
      @name = row[:first_name]
      @zipcode = clean_zipcode(row[:zipcode])
      @legislator_list = legislators(zipcode)

      save_letters
    end
  end

  def save_letters
    FileUtils.mkdir_p 'output'

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') { |file| file.puts personal_letter }
  end

  private

  def erb_template
    template_letter = File.read('form_letter.erb')
    ERB.new template_letter
  end

  def personal_letter
    erb_template.result(binding)
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, "0")[0...5]
  end

  def clean_phonenumber(phone)
    phone = phone.to_s.gsub(/[\s()-.]/, '')
    phone_s = phone.size
    return phone if phone_s == 10
    return phone[1...11] if phone[0] == "1" && phone_s == 11

    phone.rjust(10, "0")[0...10]
  end

  def legislators(zipcode)
    @civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end

  def api_key
    'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  end
end
