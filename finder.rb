require_relative 'piece'
require_relative 'track'
require 'pry'

module Pitchcar
  class Finder

    class << self
      def find_all_tracks(straight, left_right)
        tracks = find_tracks(straight - 1, left_right, 'S', [])
        tracks.map do |track|
          track.with_wall_combinations
        end.flatten
      end

      def random_valid_track(straight, left_right)
        track = nil
        until !track.nil? && track.ends_correctly? && !track.overlaps? do
          track = random_track(straight, left_right)
        end
        "Slw#{track.to_s[1..-1].gsub('S') { |_| %w(Slw Srw).sample }}"
      end

      private

      def find_tracks(straight, left_right, track_pieces, tracks)
        print "Found #{tracks.size} tracks\r"
        track = Track.build_from(track_pieces)
        return false if track.overlaps?

        return tracks << track if straight == 0 && left_right == 0 && track.ends_correctly? && !track.rotation_exists?(tracks)
        [track_pieces].product((['S'] * straight + ['L'] * left_right + ['R'] * left_right).uniq).each do |result|
          if result[1] == 'S'
            find_tracks(straight - 1, left_right, result.join, tracks)
          else
            find_tracks(straight, left_right - 1, result.join, tracks)
          end
        end
        tracks
      end

      def random_track(straight, left_right)
        left = Random.rand(1..left_right)
        right = left_right - left
        Track.build_from("S#{'S' * (straight - 1)}#{'L' * left}#{'R' * right}".split('').shuffle.join)
      end
    end
  end
end
