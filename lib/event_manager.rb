require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

class EventManager
  attr_accessor :content, :name, :zipcode, :legislator_list

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
      @name = row[:first_name]
      @zipcode = clean_zipcode(row[:zipcode])
      @legislator_list = legislators(zipcode)

      puts personal_letter
    end
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
