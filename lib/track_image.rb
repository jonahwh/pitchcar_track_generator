require 'rmagick'

module Pitchcar
  class TrackImage
    attr_accessor :track
    TILE_SIZE = 570
    OFFSET_SIZE = -50
    TITLE_OFFSET = 200
    BLANK_TILE = Magick::Image.new(TILE_SIZE, TILE_SIZE) { |canvas| canvas.background_color = 'white' }

    def initialize(track)
      self.track = track
    end

    def render
      track_image = render_track(build_tiles)
      add_title_to(track_image)
      track_image.write('track.png')
    end

    private

    def build_tiles
      min_x = track.pieces.map(&:x).min
      coordinate = { x: min_x, y: track.pieces.map(&:y).max }
      sorted_pieces = track.graph_sorted
      tiles = sorted_pieces.map(&:image)
      index = 0
      insert_index = 0
      while index < track.pieces.size - 1 do
        piece = sorted_pieces[index]
        if piece.x == coordinate[:x] && piece.y == coordinate[:y]
          index += 1
        else
          tiles.insert(insert_index, BLANK_TILE)
        end
        insert_index += 1
        new_x = (coordinate[:x] + min_x.abs + 1 ) % track.size[:x] - min_x.abs
        coordinate[:y] = new_x <= coordinate[:x] ? coordinate[:y] - 1 : coordinate[:y]
        coordinate[:x] = new_x
      end
      pieces = Magick::ImageList.new
      pieces += tiles
    end

    def render_track(piece_images)
      size = track.size
      track_montage = piece_images.montage do |montage|
        montage.tile = Magick::Geometry.new(size[:x], size[:y])
        montage.geometry = Magick::Geometry.new(TILE_SIZE, TILE_SIZE, OFFSET_SIZE, OFFSET_SIZE)
      end
      track_montage.extent(track_montage.columns, track_montage.rows + TITLE_OFFSET, 0, -TITLE_OFFSET)
    end

    def add_title_to(track_image)
      Magick::Draw.new.annotate(track_image, 0, 0, 0, 40, track.title) do
        self.font_family = 'Helvetica'
        self.pointsize = 60
        self.font_weight = Magick::BoldWeight
        self.gravity = Magick::NorthGravity
      end
    end
  end
end
