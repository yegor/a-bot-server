application.on(:start) do
  application.server do 
    Phoenix::Servers::DCell::Server.new.tap do |server|
      server.start Phoenix::Servers::DCell::Handler.new(::Phoenix.application.dispatcher).method(:handle)
    end
  end
end