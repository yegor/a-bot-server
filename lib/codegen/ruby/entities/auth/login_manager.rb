#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Entities
  module Auth
    # forward declarations
    class ServerLoginManagerLoginRequestMessage; include ProtocolBuffers::Message; clear_fields!; end
    class ServerLoginManagerLoginResponseMessage; include ProtocolBuffers::Message; clear_fields!; end

    class ServerLoginManagerLoginRequestMessage
      required ::Messages::Auth::Credential, :credential, 1
    end

    class ServerLoginManagerLoginResponseMessage
      required ::Phoenix::Messages::Mailbox, :value, 1, :entity => "Entities::Auth::Account" 
    end

    class LoginManager
    include ProtocolBuffers::Service
    clear_rpcs!

      rpc :login, "Login", ::Entities::Auth::ServerLoginManagerLoginRequestMessage, ::Entities::Auth::ServerLoginManagerLoginResponseMessage
    end
  end
end
