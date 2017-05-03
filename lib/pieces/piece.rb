require 'json'
require 'rmagick'

module Pitchcar
  module Pieces
    class Piece
      DIRECTIONS = { NORTH: 0, EAST: 1, WEST: 2, SOUTH: 3 }
      attr_accessor :direction, :x, :y, :type

      def initialize(properties)
        self.x = properties[:x]
        self.y = properties[:y]
        self.direction = properties[:direction]
      end

      def self.first_from_string(piece_string)
        Pieces::Piece.type_from_string(piece_string).new(x: 0, y: 0, direction: DIRECTIONS[:SOUTH])
      end

      def self.type_from_string(string)
        case string
        when 'S'
          Straight
        when 'L'
          Left
        when 'R'
          Right
        end
      end

      def to_h
        { x: x, y: y, type: name, direction_name: DIRECTIONS.key(direction).downcase, direction: direction }
      end

      def name
        self.class.name.split('::').last
      end

      def coordinate
        { x: x, y: y }
      end

      private

      def north?
        direction == DIRECTIONS[:NORTH]
      end

      def south?
        direction == DIRECTIONS[:SOUTH]
      end

      def west?
        direction == DIRECTIONS[:WEST]
      end

      def east?
        direction == DIRECTIONS[:EAST]
      end
    end
  end
end
