module SpicedGracken
  module Message
    class Connection < Base

      def display
        address = @payload['sender']['location']
        last_alias = @payload['sender']['name']
        SpicedGracken.server_list.add(address, last_alias)
      end

    end
  end
end