# Company

Any company

## How to install

To install on your system, run

    gem install company

To use inside a bundled Ruby project, add this line to the `Gemfile`:

    gem 'company', '~> 0.1.0'

Below 1.0 the pin names the patch as well as the minor, so `bundle update` stops short of
`0.2.0`. Semantic Versioning lets a `0.x` release break whatever it likes, and only promises
otherwise once the major is real -- at which point the pin loosens to `~> 1.0`.

## Development

`bin/setup` gets a clone working, `bin/console` opens a prompt with the library loaded, and
`bundle exec rake` runs the suite and the linter -- which is what CI runs too.

## Reference

The API reference is built from what RubyGems holds, at
[rubydoc.info/gems/company](https://rubydoc.info/gems/company). The source is at
[github.com/claudiob/company](https://github.com/claudiob/company).

## License

MIT, see [LICENSE.txt](LICENSE.txt).
