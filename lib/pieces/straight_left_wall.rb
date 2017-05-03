module Pitchcar
  module Pieces
    class StraightLeftWall < Straight
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
        'Slw'
      end
    end
  end
end
