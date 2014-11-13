# Rspec::Axlsx::Formatter

"rspec-axlsx-formatter" is a [RSpec](http://github.com/rspec) custom formatter that uses [Axlsx](https://github.com/randym/axlsx) and generate xlsx file as spec result.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-axlsx-formatter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-axlsx-formatter

## Usage

Require the follow in your Rakefile.

```
require 'rspec/axlsx/rake/rspec'
```

And, add `axlsx:setup:rspec` at rake command.


Example)

```
rake axlsx:setup:rspec spec
```

This usage is similar to ci_report_rspec.
(In actuality, I use ci_report_rspec as reference.)

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rspec-axlsx-formatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Liscense

MIT
