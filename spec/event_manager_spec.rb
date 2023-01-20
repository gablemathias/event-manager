require 'event_manager'

describe "EventManager" do
  fname = "filename.csv"
  File.delete(fname) if File.exist? fname
  File.open(fname,'w+') do |file|
    file.puts " ,first_name,last_name,age"
    file.puts "1,Gabriel,Mathias,26"
  end

  it "creates EventManager object" do
    file = EventManager.new(fname)
    expect(file.class).to be(EventManager)
  end

  describe "#show_name" do
    it "return name" do
      file = EventManager.new(fname)
      expect(file.show_name 0, 'first_name').to eql("Gabriel")
    end
  end
end
