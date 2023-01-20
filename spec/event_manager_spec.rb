require 'event_manager'

describe "EventManager" do
  fname = "event_attendees.csv"

  it "creates EventManager object" do
    file = EventManager.new(fname)
    expect(file.class).to be(EventManager)
  end
end
