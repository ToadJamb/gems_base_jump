Gem::Specification.new do |spec|
  spec.name          = 'base_jump'
  spec.version       = '0.0.1'
  spec.authors       = ['Travis Herrick']
  spec.email         = ['tthetoad@gmail.com']
  spec.summary       = 'Application framework'
  spec.description   = '
    Jump start your application by base jumping your app
  '.strip
  spec.homepage      = 'http://www.bitbucket.org/ToadJamb/gems_base_jump'
  spec.license       = 'LGPLV3'

  spec.files         = Dir['lib/**/*.rb', 'license/*']

  spec.extra_rdoc_files << 'readme.md'

  spec.add_development_dependency 'rake_tasks'
  spec.add_development_dependency 'gems'
end
