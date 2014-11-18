require 'celluloid/io'

Celluloid::IO::Stream.class_eval do
  # System write via the nonblocking subsystem
  def syswrite(string)
    length = string.length
    total_written = 0

    remaining = string

    @write_latch.synchronize do
      while total_written < length
        begin
          written = write_nonblock(remaining)
        rescue ::IO::WaitWritable
          wait_writable
          retry
        rescue EOFError
          return total_written
        rescue Errno::EAGAIN
          wait_writable
          retry
        end

        total_written += written

        # FIXME: mutating the original buffer here. Seems bad.
        remaining.slice!(0, written) if written < remaining.length
      end
    end

    total_written
  end

end

application.on(:start) do
  application.server do 
    Phoenix::Servers::TCP::Server.new.tap do |server|
      server.start Phoenix::Servers::TCP::Handler.new.method(:handle)
    end
  end

  ::Entities::Auth::LoginManager.new
  ::Entities::Game::MatchMaker.new
end