#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Messages
  module Game
    module Base
      # forward declarations
      class Cell; include ProtocolBuffers::Message; clear_fields!; end

      class Cell
        required :int32, :id, 1
        required :int32, :playerId, 2
        required :int32, :armySize, 3
      end

    end
  end
end
