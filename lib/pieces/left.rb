module Pitchcar
  module Pieces
    class Left < Piece
      IMAGE = Magick::Image.read(File.expand_path('../images/curve_tile.png', __FILE__))[0]

      def next_direction
        if north?
          DIRECTIONS[:WEST]
        elsif east?
          DIRECTIONS[:NORTH]
        elsif west?
          DIRECTIONS[:SOUTH]
        elsif south?
          DIRECTIONS[:EAST]
        end
      end

      def next_coordinate
        if north?
          { x: x - 1, y: y }
        elsif east?
          { x: x, y: y + 1 }
        elsif west?
          { x: x, y: y - 1 }
        elsif south?
          { x: x + 1, y: y }
        end
      end

      def image
        if north?
          IMAGE.rotate(180)
        elsif east?
          IMAGE.rotate(270)
        elsif west?
          IMAGE.rotate(90)
        elsif south?
          IMAGE
        end
      end

      def to_s
        'L'
      end
    end
  end
end
