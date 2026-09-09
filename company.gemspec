require_relative 'lib/company/version'

Gem::Specification.new do |spec|
  spec.name        = 'company'
  spec.version     = Company::VERSION
  spec.authors     = [ 'Claudio Baccigalupo' ]
  spec.email       = [ 'claudiob@users.noreply.github.com' ]
  spec.homepage    = 'https://github.com/claudiob/company'
  spec.summary     = 'Any company'
  spec.description = 'The records a field-service business holds, whichever platform holds them'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/claudiob/company/'
  spec.metadata['changelog_uri']     = 'https://github.com/claudiob/company/blob/main/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/company'
  spec.required_ruby_version         = '>= 3.2.0'

  spec.files = `git ls-files -z lib CHANGELOG.md LICENSE.txt README.md`.split "\x0"

  spec.add_dependency 'activesupport' # presence, to_sentence and an indifferent node go without it
end
