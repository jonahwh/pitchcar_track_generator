module Pitchcar
  module Pieces
    class Start < Straight
      IMAGE = Magick::Image.read(File.expand_path('../images/start_tile.png', __FILE__))[0]

      def image
        if north?
          IMAGE.rotate(270)
        elsif east?
          IMAGE
        elsif west?
          IMAGE.rotate(180)
        elsif south?
          IMAGE.rotate(90)
        end
      end

      def to_s
        'St'
      end
    end
  end
end
