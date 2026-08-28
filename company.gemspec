require_relative 'lib/company/version'

Gem::Specification.new do |spec|
  spec.name        = 'company'
  spec.version     = Company::VERSION
  spec.authors     = [ 'Claudio Baccigalupo' ]
  spec.email       = [ 'claudiob@users.noreply.github.com' ]
  spec.homepage    = 'https://github.com/claudiob/company'
  spec.summary     = 'Any company'
  spec.description = 'A library to expose endpoint for a generic company'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/claudiob/company/'
  spec.metadata['changelog_uri']     = 'https://github.com/claudiob/company/blob/main/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/company'
  spec.required_ruby_version         = '>= 3'

  spec.files = `git ls-files -z lib CHANGELOG.md LICENSE.txt README.md`.split "\x0"
end
