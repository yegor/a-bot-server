application.on(:start) do
  application.server do 
    Phoenix::Servers::TCP::Server.new.tap do |server|
      server.start(lambda do |connection, call|
        puts "!!! Received a packet via TCP"
        p call

        sleep 5.0

        connection.send( call )
      end)
    end
  end
end