application.on(:start) do
  application.server do 
    Phoenix::Servers::DCell::Server.new.tap do |server|
      server.start(lambda do |call|
        ::Phoenix.application.dispatcher.dispatch(call)
      end)
    end
  end
end