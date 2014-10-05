module Entities
  module System

    #  Simple system entity dedicated to testing connectivity, computing
    #  ping time and so on.
    #
    class Echo
      
      include ::Phoenix::Entity::Base

      presence :local

      #  Just returns the result back.
      def ask(request)
        puts "== Often I am asked: What does a hero truly need? Kekeke... Much depends upon a hero. #{request.inspect}"
        request.phrase
      end

      #  Same as echo – but works with numbers!
      def ping(request)
        sleep 3
        request.time
      end

      #  Creates and returns a new handle entity.
      #
      def handle(request)
        ::Entities::System::Handle.new
      end

    end

  end
end