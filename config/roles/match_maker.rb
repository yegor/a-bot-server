application.on(:start) do
  ::Entities::Game::MatchMaker.new
end