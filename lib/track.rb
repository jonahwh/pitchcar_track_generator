require 'csv'
require 'bazaar'
require 'digest'
require_relative 'pieces/piece'
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
      track = Track.new([Pieces::Piece.first_from_string(track_pieces.chars.first)], size_restrictions)
      track_pieces.chars[1..-1].each do |piece_str|
        track.pieces << Pieces::Piece.type_from_string(piece_str).new(track.pieces.last.next_coordinate.merge(direction: track.pieces.last.next_direction))
      end
      track
    end

    def valid?(tracks=[])
      ends_correctly? && !overlaps? && !rotation_exists?(tracks) && within_size_restrictions?
    end

    def to_s
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
      string = to_s
      @overlaps ||= string.include?('LLL') || string.include?('RRR') ||  pieces.group_by { |piece| [piece.x, piece.y] }.values.any? { |set| set.size > 1 }
    end

    def with_wall_combinations(pieces = self.pieces, tracks = [])
      straight_index = pieces.find_index { |piece| piece.instance_of? Pieces::Straight }
      if straight_index
        pieces_copy = pieces.dup

        [Pieces::StraightLeftWall, Pieces::StraightRightWall].map do |piece_type|
          pieces_copy[straight_index] = piece_type.new(pieces[straight_index].to_h)
          with_wall_combinations(pieces_copy, tracks)
        end.last
      else
        tracks << Track.new(pieces.dup).assign_start_piece
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

    def assign_start_piece
      start_index = pieces.each_index.select { |i| pieces[i].is_a? Pieces::StraightRightWall }.sample
      # If there are no straight right pieces, pick any straight piece to be the start
      start_index = pieces.each_index.select { |i| pieces[i].is_a? Pieces::Straight }.sample if start_index.nil?
      self.pieces[start_index] = Pieces::Start.new(pieces[start_index].to_h)
      self
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
      pieces.last.next_coordinate == pieces.first.coordinate && pieces.last.next_direction == Pieces::Piece::DIRECTIONS[:SOUTH]
    end

    def within_size_restrictions?
      size[:x].between?(self.min_size[:x], self.max_size[:x]) && size[:y].between?(self.min_size[:y], self.max_size[:y])
    end

    def hash
      Digest::SHA256.hexdigest(to_s)
    end
  end
end
