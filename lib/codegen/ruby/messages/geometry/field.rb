#!/usr/bin/env ruby
# Generated by the protocol buffer compiler. DO NOT EDIT!

require 'protocol_buffers'

module Messages
  module Geometry
    # forward declarations
    class Field; include ProtocolBuffers::Message; clear_fields!; end

    class Field
      repeated ::Messages::Geometry::Cell, :cells, 1
    end

  end
end
