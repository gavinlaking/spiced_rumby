
require 'spec_helper'

describe 'Message Coloring' do

  before(:each) do
    mock_settings_objects
  end

  describe 'chats' do
    context 'are received' do
      before(:each) do
        allow_any_instance_of(SpicedGracken::Http::Server).to receive(:listen){}

        json = '{"type":"chat","message":"hi","client":"Spiced Gracken","client_version":"0.1.2","time_sent":"2015-09-30 10:36:13 -0400","sender":{"alias":"nvp","location":"nvp","uid":"1"}}'
        json = JSON.parse(json)

        # sanity
        s = SpicedGracken::Http::Server.new
        @msg = msg = s.processes_message(json)
        expect(msg.display).to include("nvp")
        expect(msg.display).to include("hi")
      end

      it 'is forwarded to the chat colorizer' do
        expect(SpicedGracken.ui).to receive(:chat)
        SpicedGracken::Display.present_message @msg
      end
    end
  end
end
