require 'csv'
require 'bazaar'
require_relative 'piece'
require_relative 'track_image'
require_relative 'boyermoore'

module Pitchcar
  class Track
    attr_accessor :pieces, :max_size, :min_size

    def initialize(pieces, size_restrictions = {})
      self.pieces = pieces
      self.max_size = size_restrictions.fetch(:max, x: Float::INFINITY, y: Float::INFINITY)
      self.min_size = size_restrictions.fetch(:min, x: 1, y: 1)
    end

    def self.build_from(track_pieces, size_restrictions = {})
      pieces = PieceList.new([Piece.starting_piece])

      track_pieces[1..-1].chars.each do |piece_str|
        piece = Piece.new
        piece.x = pieces.last.x
        piece.y = pieces.last.y
        piece.type = Piece.type_from_string(piece_str)

        case pieces.last.direction
        when Piece::DIRECTIONS[:NORTH]
          piece.y = pieces.last.y + 1
        when Piece::DIRECTIONS[:EAST]
          piece.x = pieces.last.x + 1
        when Piece::DIRECTIONS[:WEST]
          piece.x = pieces.last.x - 1
        when Piece::DIRECTIONS[:SOUTH]
          piece.y = pieces.last.y - 1
        end
        piece.direction = piece.next_direction(pieces.last.direction)

        pieces << piece
      end

      Track.new(pieces, size_restrictions)
    end

    def valid?(tracks=[])
      ends_correctly? && !overlaps? && !rotation_exists?(tracks) && within_size_restrictions?
    end

    def to_s
      pieces[0].type = Piece::TYPES[:STRAIGHT_RIGHT_WALL]
      pieces.map(&:to_s).join(' ')
    end

    def to_json
      pieces.map(&:to_h).to_json
    end

    def to_png
      TrackImage.new(self).render
      puts "Track image saved to #{Dir.pwd}/track.png"
    end

    def size
      x_coords = pieces.map(&:x)
      y_coords = pieces.map(&:y)
      # We have to add one, because a piece takes up a discrete distance
      { x: x_coords.max - x_coords.min + 1, y: y_coords.max - y_coords.min + 1 }
    end

    def overlaps?
      @overlaps ||= pieces.group_by { |piece| [piece.x, piece.y] }.values.any? { |set| set.size > 1 }
    end

    def with_wall_combinations(pieces = PieceList.new(self.pieces)[1..-1], combinations = [])
      straight_index = pieces.find_index { |piece| piece.type == Piece::TYPES[:STRAIGHT] }
      if straight_index
        combos = []
        [Piece::TYPES[:STRAIGHT_LEFT_WALL], Piece::TYPES[:STRAIGHT_RIGHT_WALL]].each do |piece_type|
          pieces_copy = PieceList.new(pieces)
          pieces_copy[straight_index].type = piece_type
          combos = with_wall_combinations(pieces_copy, combinations)
        end
        combos
      else
        combinations << Track.new([self.pieces.first] + pieces)
      end
    end

    # Returns pieces list sorted from in a top-bottom left-right manner
    def graph_sorted
      pieces.sort do |piece, other_piece|
        if piece.y == other_piece.y
          piece.x <=> other_piece.x
        else
          other_piece.y <=> piece.y
        end
      end
    end

    def title
      results = { nouns: [], adjs: [] }
      [{ name: :nouns, types: %w(items superitems) }, {name: :adjs, types: %w(adj superadj) }].each do |part|
        part[:types].each do |type|
          Random.srand(hash.hex)
          results[part[:name]] << Bazaar.get_item(type).capitalize
        end
      end
      Random.srand(hash.hex)
      "#{results[:adjs].sample} #{results[:nouns].sample}"
    end

    private

    def rotation_exists?(tracks)
      tracks.each do |other_track|
        other_track = other_track.to_s.gsub(' ', '') * 2
        return true unless BoyerMoore.search(other_track, to_s.gsub(' ', '')).nil?
      end
      false
    end

    def ends_correctly?
      pieces.last.x == pieces.first.x && pieces.last.y == pieces.first.y + 1 && pieces.last.direction == Piece::DIRECTIONS[:SOUTH]
    end

    def within_size_restrictions?
      size[:x].between?(self.min_size[:x], self.max_size[:x]) && size[:y].between?(self.min_size[:y], self.max_size[:y])
    end

    def hash
      Digest::SHA256.hexdigest(to_s)
    end
  end

  class PieceList < Array
    def initialize(pieces)
      pieces.each do |piece|
        new_piece = Piece.new
        new_piece.x = piece.x
        new_piece.y = piece.y
        new_piece.type = piece.type
        new_piece.direction = piece.direction
        self.<< new_piece
      end
    end
  end
end
