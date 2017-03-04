Gem::Specification.new do |spec|
  spec.name        = 'pitchcar'
  spec.version     = '0.6.2'
  spec.date        = '2017-02-23'
  spec.summary     = 'Pitchcar Track Generator'
  spec.description = 'Generates tracks for pitchcar'
  spec.authors     = ['Jonah Hirsch']
  spec.email       = 'jhirsch@rmn.com'
  spec.homepage    = 'https://github.com/jonahwh/pitchcar_track_generator'
  spec.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.license     = 'MIT'

  spec.add_runtime_dependency 'bazaar'
  spec.add_runtime_dependency 'rmagick'
end
