require 'csv'
require_relative 'piece'
require_relative 'boyermoore'

module Pitchcar
  class Track
    attr_accessor :pieces

    def initialize(pieces)
      self.pieces = pieces
    end

    def self.build_from(track_pieces)
      pieces = [Piece.starting_piece]

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

      Track.new(pieces)
    end

    def rotation_exists?(tracks)
      tracks.each do |other_track|
        return true unless BoyerMoore.search("#{other_track.to_s}#{other_track.to_s}", to_s).nil?
      end
      false
      # tracks.find do |other_track|
      #   "#{to_s}#{to_s}".include? other_track.to_s
      # end != nil
    end

    def ends_correctly?
      pieces.last.x == pieces.first.x && pieces.last.y == pieces.first.y + 1 && pieces.last.direction == Piece::DIRECTIONS[:SOUTH]
    end

    def to_s
      pieces.map { |piece| Piece::TYPES.key(piece.type).to_s[0] }.join
    end

    def overlaps?
      pieces.group_by { |piece| [piece.x, piece.y] }.values.any? { |set| set.size > 1 }
    end
  end
end
