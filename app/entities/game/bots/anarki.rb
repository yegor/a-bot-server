module Entities
  module Game
    module Bots

      #  A very dump kind of bot. Makes from 0 to 5 moves, which are just
      #  possible, and quits.
      #
      class Anarki
        include ::Phoenix::Entity::Base
        presence :local
        logger_scope "Anarki"

        #  An abstract class, which sole purpose is to act as a dynamic proxy.
        #
        class Image
          include Phoenix::Entity::Extensions::Image

          #  Fowards specified method's invokation into the block passed.
          #
          def initialize(owner, prefix, entity)
            super(entity)
            @prefix = prefix
            @owner = owner
          end

          #  Check the responder chain.
          #
          def respond_to?(method, include_private = false)
            @owner.respond_to?(@prefix.to_s + method.to_s) || super
          end

          #  Foward the invokation.
          #
          def method_missing(method, *args, &block)
            name = @prefix.to_s + method.to_s

            if @owner.respond_to?(name)
              @owner.send(name, *args, &block)
            else
              super
            end
          end

        end

        #  Holds world for this bot
        attr_accessor :world

        #  Match maker image
        attr_accessor :match_maker

        #  Match image
        attr_accessor :match

        #  Player image
        attr_accessor :player

        #  Initializes the bot with the match_maker instance.
        #
        def initialize(match_maker)
          setup_world(match_maker)
        end

        #  Returns world (as it is a connection for this bot).
        #
        def connection
          self.world
        end

      protected

        #  Sets the world up for this bot.
        #
        def setup_world(match_maker)
          self.world = Phoenix::Entity::World.new
          self.world.within do
            self.match_maker = Image.new(self, :match_maker_, match_maker)
          end
        end

        #
        #  Bot logic goes here
        #

        #  Handles match ready message.
        #
        def match_maker_match_ready(match, player)
          self.world.within do
            self.match = Image.new(self, :match_, match)
            self.player = Image.new(self, :player_, player)
          end
        end

        #  Not sure if this shall even happen, but stil.
        #
        def match_maker_match_timed_out
        end

        #  Handles cell update.
        #
        def match_update_cell(cell)
          # we don't handle anything here – we have a quick access to real match entity anyway
        end
        
        #  Handles turn switch.
        #
        def match_switch_turn(player)
          try_do_some_fancy_moves if player.id == self.player.id
        end

        #  Tries to make some moves.
        #
        def try_do_some_fancy_moves
          moves = 2 + rand(3)
          
          timer = every(2.0) do
            moves -= 1

            if moves < 0
              logger.debug "Done making stupid moves"
              timer.cancel
              player.end_turn
            else
              make_one_move
            end
          end
        end

        #  Makes one legit move.
        #
        def make_one_move
          enemy_id = nil

          cells = self.match.state.field.cells.shuffle
          
          cell = cells.detect do |candidate| 
            enemy_id = candidate.neighbours.detect { |id| self.match.state.field.get_cell_by_id(id).player_id != self.player.id }
            candidate.player_id == self.player.id && enemy_id.present?
          end

          if cell.present?
            logger.debug "Making move from #{cell.id} onto #{enemy_id}"
            player.make_move( cell.id, enemy_id )
          else
            logger.debug "No moves found :("
          end
        end

      end

    end
  end
end
