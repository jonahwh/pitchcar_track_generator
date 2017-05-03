module Pitchcar
  module Pieces
    class Right < Piece
      IMAGE = Magick::Image.read(File.expand_path('../images/curve_tile.png', __FILE__))[0]

      def next_direction
        if north?
          DIRECTIONS[:EAST]
        elsif east?
          DIRECTIONS[:SOUTH]
        elsif west?
          DIRECTIONS[:NORTH]
        elsif south?
          DIRECTIONS[:WEST]
        end
      end

      def next_coordinate
        if north?
          { x: x + 1, y: y }
        elsif east?
          { x: x, y: y - 1 }
        elsif west?
          { x: x, y: y + 1 }
        elsif south?
          { x: x - 1, y: y }
        end
      end

      def image
        if north?
          IMAGE.rotate(90)
        elsif east?
          IMAGE.rotate(180)
        elsif west?
          IMAGE
        elsif south?
          IMAGE.rotate(270)
        end
      end

      def to_s
        'R'
      end
    end
  end
end
