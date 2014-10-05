module Messages
  module Common

    class Mailbox

      include ::Phoenix::Messages::Base

      #  Handles mailbox initialization with an entity.
      #
      def initialize(options = {})
        if options[:value]
          entity = options.delete(:value)
          super(entity: entity.klass.name, id: entity.id)
        else
          super
        end
      end

    end

  end
end
