#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Messages
  module Game
    module Base
      # forward declarations
      class MatchState; include ProtocolBuffers::Message; clear_fields!; end

      class MatchState
        required ::Messages::Game::Base::Field, :field, 1
        required ::Messages::Game::Base::MatchPlayers, :players, 2
        required :int32, :turnNumber, 3
        required :int32, :turnPlayerId, 4
      end

    end
  end
end
