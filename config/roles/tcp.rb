application.on(:start) do
  application.server do 
    Phoenix::Servers::TCP::Server.new.tap do |server|
      server.start(lambda do |connection, cpacket|
        #  parse RPC envelope from incoming CPacket
        envelope = ::Phoenix::RPC::Envelope.parse( cpacket.chunks.first.data )
        
        #  process RPC CALL envelope 
        if envelope.type == ::Phoenix::RPC::Envelope::EnvelopeType::CALL
          entity_class = envelope.call.entity.classify.constantize

          #  convert method name
          envelope.call.method = entity_class.convert_rpc_method_name( envelope.call.method )

          #  parse args (using meta information from entity in question)
          envelope.call.args = [ entity_class.parse_args( envelope.call.method, envelope.call.args_bytes ) ]

          #  dispatch the result and grab the value
          value = ::Phoenix.application.dispatcher.dispatch(envelope.call)

          #  wrap it into Protocol Buffers message corresponding to the call
          value = entity_class.wrap_result( envelope.call.method, value )

          #  compose RPC result
          result = ::Phoenix::RPC::Result.new(cookie: envelope.call.cookie, result_bytes: value.serialize_to_string)

          #  compose response envelope
          response = ::Phoenix::RPC::Envelope.new(type: ::Phoenix::RPC::Envelope::EnvelopeType::RESULT, result: result)
          
          #  and send it back (wrapped in CPacket)
          connection.send( ::Phoenix::Servers::TCP::Cpacket::Packet.new( response.serialize_to_string ) )
        end
      end)
    end
  end

  $echo = ::Entities::System::Echo.new
end