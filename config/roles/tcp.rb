application.on(:start) do
  application.server do 
    Phoenix::Servers::TCP::Server.new.tap do |server|
      server.start Phoenix::Servers::TCP::Handler.new(::Phoenix.application.dispatcher).method(:handle)
    end
  end

  ::Entities::System::Echo.new
end