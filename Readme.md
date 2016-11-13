# PitchCar Track Generator

Generates all possible tracks, or a single random valid track, for
[PitchCar](https://boardgamegeek.com/boardgame/150/pitchcar)

## Rules:
* Tracks will always begin with a straight piece
* Tracks must not overlap
* Tracks must form a complete look
* Track must not already have been found as a rotation

## Usage:
### Generate all possible tracks
```ruby
require_relative 'finder.rb'
# tracks = Pitchcar::Finder.find_all_tracks(STRAIGHT_PIECES, LEFT_RIGHT_PIECES)
tracks = Pitchcar::Finder.find_all_tracks(6, 10)
tracks.first.to_s # => 'Slw Slw Slw Slw L Slw L Slw L R R L L R L L'
```

All possible values for a basic PitchCar set (10 curves, 6 straight pieces)
are provided in `pitchcar_tracks`
* `Slw` = Straight piece with left wall
* `Srw` = Straight piece with right wall
* `R` = Right Turn
* `L` = Left Turn

### Find a random valid track
```ruby
require_relative 'finder.rb'
# track = Pitchcar::Finder.random_valid_track(STRAIGHT_PIECES, LEFT_RIGHT_PIECES)
track = Pitchcar::Finder.random_valid_track(6, 10)
track.to_s # => 'Slw Slw L Slw R R Slw Slw R L R R L Slw R R'
