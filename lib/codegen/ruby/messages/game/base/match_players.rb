#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Messages
  module Game
    module Base
      # forward declarations
      class MatchPlayers; include ProtocolBuffers::Message; clear_fields!; end

      class MatchPlayers
        repeated ::Phoenix::Messages::Mailbox, :players, 1, :entity => "Entities::Game::Base::Player" 
      end

    end
  end
end