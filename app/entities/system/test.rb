module Entities
  module System

    class Test

      include ::Phoenix::Entity::Base

      presence :global

      #  Result is:
      #    Entities::System::Outer( Entities::System::Handle h, Entities::System::Handle[] hh )
      #
      def outgoing
        raise NotImplementedError.new
      end


    end

  end
end
