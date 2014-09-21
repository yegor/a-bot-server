application.on(:start) do
  application.server do 
    Phoenix::Servers::DCell::Server.new.tap do |server|
      server.start(lambda do |call|
        puts "!!! Received a packet via DCell"
        p call
      end)
    end
  end
end