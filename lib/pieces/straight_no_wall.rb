module Pitchcar
  module Pieces
    class StraightNoWall < Straight
      IMAGE = Magick::Image.read(File.expand_path('../images/straight_tile_no_wall.png', __FILE__))[0]

      def to_s
        'Snw'
      end
    end
  end
end
