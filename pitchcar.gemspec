Gem::Specification.new do |s|
  s.name        = 'pitchcar'
  s.version     = '0.3.0'
  s.date        = '2017-02-23'
  s.summary     = 'Pitchcar Track Generator'
  s.description = 'Generates tracks for pitchcar'
  s.authors     = ['Jonah Hirsch']
  s.email       = 'jhirsch@rmn.com'
  s.homepage    = 'https://github.com/jonahwh/pitchcar_track_generator'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.license     = 'MIT'
end
