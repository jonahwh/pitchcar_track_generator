module Pitchcar
  module Pieces
    class Straight < Piece
      IMAGE = Magick::Image.read(File.expand_path('../images/straight_tile.png', __FILE__))[0]
      def next_direction
        direction
      end

      def next_coordinate
        if north?
          { x: x, y: y + 1 }
        elsif east?
          { x: x + 1, y: y }
        elsif west?
          { x: x - 1, y: y }
        elsif south?
          { x: x, y: y - 1 }
        end
      end

      def image
        return self.class::IMAGE.rotate(90) if north? || south?
        self.class::IMAGE
      end

      def to_s
        'S'
      end
    end
  end
end
