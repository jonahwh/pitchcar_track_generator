require 'json'

module Pitchcar
  class Piece
    TYPES = { STRAIGHT: 0, LEFT: 1, RIGHT: 2, STRAIGHT_LEFT_WALL: 3, STRAIGHT_RIGHT_WALL: 4 }
    DIRECTIONS = { NORTH: 0, EAST: 1, WEST: 2, SOUTH: 3 }
    attr_accessor :direction, :x, :y, :type

    def self.starting_piece
      piece = new
      piece.x = 0
      piece.y = 0
      piece.type = TYPES[:STRAIGHT]
      piece.direction = DIRECTIONS[:SOUTH]
      piece
    end

    def self.type_from_string(string)
      case string
      when 'S'
        TYPES[:STRAIGHT]
      when 'L'
        TYPES[:LEFT]
      when 'R'
        TYPES[:RIGHT]
      end
    end

    def next_direction(from)
      case type
        when TYPES[:LEFT]
        case from
        when DIRECTIONS[:NORTH]
          DIRECTIONS[:WEST]
        when DIRECTIONS[:EAST]
          DIRECTIONS[:NORTH]
        when DIRECTIONS[:WEST]
          DIRECTIONS[:SOUTH]
        when DIRECTIONS[:SOUTH]
          DIRECTIONS[:EAST]
        end
      when TYPES[:RIGHT]
        case from
        when DIRECTIONS[:NORTH]
          DIRECTIONS[:EAST]
        when DIRECTIONS[:EAST]
          DIRECTIONS[:SOUTH]
        when DIRECTIONS[:WEST]
          DIRECTIONS[:NORTH]
        when DIRECTIONS[:SOUTH]
          DIRECTIONS[:WEST]
        end
      else
        from
      end
    end

    def to_s
      TYPES.key(type).to_s.split('_').map { |word| word[0] }.join.downcase.capitalize
    end

    def to_h
      { x: x, y: y, type: TYPES.key(type).downcase, direction: DIRECTIONS.key(direction).downcase }
    end
  end
end
