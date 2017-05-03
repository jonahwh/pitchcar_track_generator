module Pitchcar
  module Pieces
    class StraightRightWall < Straight
      def image
        if south?
          IMAGE.rotate(90)
        elsif west?
          IMAGE.rotate(180)
        elsif east?
          IMAGE
        elsif north?
          IMAGE.rotate(270)
        end
      end

      def to_s
        'Srw'
      end
    end
  end
end
