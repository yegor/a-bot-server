#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Entities
  module Game
    # forward declarations
    class MatchMakerPropertiesMessage; include ProtocolBuffers::Message; clear_fields!; end
    class ClientMatchMakerMatchReadyRequestMessage; include ProtocolBuffers::Message; clear_fields!; end
    class ClientMatchMakerMatchTimedOutRequestMessage; include ProtocolBuffers::Message; clear_fields!; end
    class ServerMatchMakerFindMatchRequestMessage; include ProtocolBuffers::Message; clear_fields!; end

    class MatchMakerPropertiesMessage
    end

    class ClientMatchMakerMatchReadyRequestMessage
      required ::Phoenix::Messages::Mailbox, :match, 1, :entity => "Entities::Game::Base::Match" 
      required ::Phoenix::Messages::Mailbox, :player, 2, :entity => "Entities::Game::Base::Player" 
    end

    class ClientMatchMakerMatchTimedOutRequestMessage
    end

    class ServerMatchMakerFindMatchRequestMessage
      required ::Phoenix::Messages::Mailbox, :matchRequest, 1, :entity => "Entities::Game::MatchRequest" 
    end

    class MatchMaker
      include ProtocolBuffers::Service
      clear_rpcs!
      properties MatchMakerPropertiesMessage
      client_rpc :match_ready, "MatchReady", ::Entities::Game::ClientMatchMakerMatchReadyRequestMessage, ::Phoenix::Messages::Void
      client_rpc :match_timed_out, "MatchTimedOut", ::Entities::Game::ClientMatchMakerMatchTimedOutRequestMessage, ::Phoenix::Messages::Void
      rpc :find_match, "FindMatch", ::Entities::Game::ServerMatchMakerFindMatchRequestMessage, ::Phoenix::Messages::Void
    end
  end
end
