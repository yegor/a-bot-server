module Balancer
  class Matchmaking 

    def find_match
      resolve( :storage ).profile.save( user )
    end

  end
end

module Persistence
  class Profile
    include Celluloid

    def save
    end
  end
end

class Router
  def perform_message_processing(xxx)
    ...
    Persistence::Profile.pool.save(xxx)
  end
end

class DcellReceiver
  include Celluloid

  def handle(message)
    Router.new.perform_message_processing(message)
  end
end