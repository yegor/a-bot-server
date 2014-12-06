application.on(:start) do
  ::Entities::Auth::LoginManager.new
end