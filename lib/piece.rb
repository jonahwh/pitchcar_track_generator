require 'json'
require 'rmagick'

module Pitchcar
  class Piece
    TYPES = { STRAIGHT: 0, LEFT: 1, RIGHT: 2, STRAIGHT_LEFT_WALL: 3, STRAIGHT_RIGHT_WALL: 4 }
    DIRECTIONS = { NORTH: 0, EAST: 1, WEST: 2, SOUTH: 3 }
    STRAIGHT_IMAGE, CURVE_IMAGE = Magick::ImageList.new(File.expand_path('../images/straight_tile.png', __FILE__),
                                                        File.expand_path('../images/curve_tile.png', __FILE__)).to_a
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

    # Slw N = Srw S
    # Slw E = Srw W
    # Slw W == Srw E
    # Slw S = Srw N

    def image
      if (type == TYPES[:STRAIGHT_LEFT_WALL] && direction == DIRECTIONS[:NORTH]) || (type == TYPES[:STRAIGHT_RIGHT_WALL] && direction == DIRECTIONS[:SOUTH])
        return STRAIGHT_IMAGE.rotate(90)
      elsif (type == TYPES[:STRAIGHT_LEFT_WALL] && direction == DIRECTIONS[:EAST]) || (type == TYPES[:STRAIGHT_RIGHT_WALL] && direction == DIRECTIONS[:WEST])
        return STRAIGHT_IMAGE.rotate(180)
      elsif (type == TYPES[:STRAIGHT_LEFT_WALL] && direction == DIRECTIONS[:WEST]) || (type == TYPES[:STRAIGHT_RIGHT_WALL] && direction == DIRECTIONS[:EAST])
        return STRAIGHT_IMAGE
      elsif (type == TYPES[:STRAIGHT_LEFT_WALL] && direction == DIRECTIONS[:SOUTH]) || (type == TYPES[:STRAIGHT_RIGHT_WALL] && direction == DIRECTIONS[:NORTH])
        return STRAIGHT_IMAGE.rotate(270)
      end

      case type
      when TYPES[:STRAIGHT]
        return STRAIGHT_IMAGE.rotate(90) if direction == DIRECTIONS[:NORTH] || direction == DIRECTIONS[:SOUTH]
        STRAIGHT_IMAGE
      when TYPES[:LEFT]
        case direction
        when DIRECTIONS[:NORTH]
          CURVE_IMAGE.rotate(270)
        when DIRECTIONS[:EAST]
          CURVE_IMAGE
        when DIRECTIONS[:WEST]
          CURVE_IMAGE.rotate(180)
        when DIRECTIONS[:SOUTH]
          CURVE_IMAGE.rotate(90)
        end
      when TYPES[:RIGHT]
        case direction
        when DIRECTIONS[:NORTH]
          CURVE_IMAGE
        when DIRECTIONS[:EAST]
          CURVE_IMAGE.rotate(90)
        when DIRECTIONS[:WEST]
          CURVE_IMAGE.rotate(270)
        when DIRECTIONS[:SOUTH]
          CURVE_IMAGE.rotate(180)
        end
      end
    end
  end
end
