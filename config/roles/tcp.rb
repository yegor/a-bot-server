application.on(:start) do
  application.server do 
    Phoenix::Servers::TCP::Server.new.tap do |server|
      server.start Phoenix::Servers::TCP::Handler.new.method(:handle)
    end
  end

  ::Entities::Auth::LoginManager.new
  ::Entities::Game::MatchMaker.new
end