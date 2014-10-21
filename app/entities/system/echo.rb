module Entities
  module System

    #  Simple system entity dedicated to testing connectivity, computing
    #  ping time and so on.
    #

    #  Client-side methods available through this entity:
    #
    #  notify( string name, int32 data )
    #  handled( Entities::System::Handle handle )
    #

    class Echo
      
      include ::Phoenix::Entity::Base

      presence :local

      #  Arguments are:
      #    question: string
      #
      #  Result is:
      #    string
      #
      def ask(question)
        Entities::System::Handle.resolve(question).increment.to_s
      end

      #  Arguments are:
      #    time: int32
      #
      #  Result is:
      #    int32
      #
      def ping(time)
        "abc"
      end

      #  Result is:
      #    Entities::System::Handle
      #
      def handle
        Entities::System::Handle.new
      end

      #  Result is:
      #    Entities::System::ManyEntities
      #
      def handles
        h = Entities::System::Handle.new
        Entities::System::ManyEntities.new( handles: (0..20).map { h } )
      end

      #  Arguments are:
      #    handle: Entities::System::Handle
      #
      #  Result is:
      #    (void)
      #
      def blah(handle)
        puts handle
      end

      #  Result is:
      #    string
      #
      def gimme_test
        Entities::System::Test.new.entity_id
      end

    end

  end
end