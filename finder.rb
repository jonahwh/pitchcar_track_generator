require_relative 'piece'
require_relative 'track'
require 'pry'

module Pitchcar
  class Finder
    @had_rotation = @no_ending = @overlaps = @total_tracks = 0
    def self.find_tracks(straight, left_right, track_pieces, tracks = [])
      print "#{tracks.size} tracks found. #{@had_rotation} rotations rejected. #{@no_ending} tracks ended incorrectly. #{@overlaps} tracks overlap. Total Tracks: #{@total_tracks}\r"

      track = Track.build_from(track_pieces)
      if track.overlaps?
        @overlaps += 1
        return false
      end

      if straight == 0 && left_right == 0
        @total_tracks += 1
        if !track.ends_correctly?
          @no_ending += 1
        elsif track.rotation_exists?(tracks)
          @had_rotation += 1
        else
          return tracks << track
        end
      else
        [track_pieces].product((['S'] * straight + ['L'] * left_right + ['R'] * left_right).uniq).each do |result|
          if result[1] == 'S'
            find_tracks(straight - 1, left_right, result.join, tracks)
          else
            find_tracks(straight, left_right - 1, result.join, tracks)
          end
        end
      end
      tracks
    end

    def self.random_valid_track(straight, left_right)
      track = random_track(straight, left_right)
      until track.ends_correctly? && !track.overlaps? do
        track = random_track(straight, left_right)
      end
      track
    end

    def self.random_track(straight, left_right)
      left = Random.rand(1..left_right)
      right = left_right - left
      Track.build_from("#{'S' * straight}#{'L' * left}#{'R' * right}".split('').shuffle.join)
    end
  end
end
