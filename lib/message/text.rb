class Message::Text
	include Encryptor

	TYPE = "text"

	attr_accessor :payload, :time_recieved

	def initialize(
		message: "",
		name_of_sender: "",
		location: "localhost")

		@payload = {
			"type" => TYPE,
			"message" => message,
			"client" => Gracken::NAME,
			"client_version" => Gracken::VERSION,
			"time_sent" => nil, # not yet sent
			"sender" => {
				"name" => name_of_sender,
				"location" => location
			}
		}
		@time_recieved = Time.now
	end

	def display
		time_recieved = @time_recieved.strftime("%e/%m/%y %H:%I:%M").colorize(:magenta)
		s = "#{time_recieved} "
		s << "#{payload["sender"]["name"].colorize(:cyan)} > "
		s << "#{payload["message"]}"
		puts s
	end

	# this message should be called immediately 
	# before sending to the whomever
	def render
		@payload[:time_sent] = Time.now
		@payload.to_json
	end
end